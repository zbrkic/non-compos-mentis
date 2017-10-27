---
title: "Couchbase on Kubernetes"
excerpt: "Running Couchbase Server on Kubernetes."
categories: Technical
tags: [technical, java, couchbase, kubernetes]
---

## Introduction

With the paradigm shift towards Microservices and Cloud-Native architecture (whether everyone is doing it right is another topic though), containers have become almost synonymous with those terms. Given that Kubernetes is a "Production-Grade Container Orchestration" (their words), and with features like horizontal scaling, self-healing, and storage orchestration, it is only natural that we are discussing running a database as a container on Kubernetes. In this post, I discuss running a Couchbase cluster on Kubernetes. I assume familiarity with both Couchbase and Kubernetes, as well as [RxJava](https://github.com/ReactiveX/RxJava) and [Hystrix](https://github.com/Netflix/Hystrix), all of which are required for the rest of this write-up.

From now on, I will refer to the Couchbase server as _CB_, the Couchbase client application as the _client_, and Kubernetes as _K8S_.

{: .notice--warning}
This is not a meant to be a recipe for running a highly-available, fully-redundant, multi-node CB cluster on K8S in Production. As of this writing, CB does not officially support running on K8S. This is a narrative of my experiences and learnings; YMMV and most likely will.

{: .notice--info}
The term connection is used loosely here to indicate a logical connection, and is not to be taken as a physical TCP/IP connection.

## Problem Statement

We want to run a CB cluster on K8S, and must support the following use cases:
* The client startup must be resilient of CB failure/availability.
* The client must not fail the request, but return a degraded response instead, if CB is not available.
* The client must reconnect should a CB failover happens.
* CB server must be able restart without human intervention; while this may sound trivial, I will later discuss why it is not.

We will not discuss the following:
* Multi-node CB cluster.
* [Failover](https://developer.couchbase.com/documentation/server/current/clustersetup/failover.html).

## Architecture

Now that we have laid out the basics, let's analyze each item of the problem statement in detail.

* **Client Startup**

  Our client is a Spring Boot app, which used to use [Spring Data Couchbase](http://projects.spring.io/spring-data-couchbase/) for CB integration. Spring Data Couchbase initializes various CB related beans at startup, and a failure to connect to CB is fatal. I tried to work my way around that limitation, but soon realized it wouldn't work; I needed to roll my own CB client code. At this point, let me ask you this:

  > What do you think is most needed to handle CB connection failure at startup?

  The answer is flippantly simple: Do not initialize CB connection at startup. When do we do it then? Umm, perhaps on the first request? That could work but the CB cluster and bucket opening are time-consuming operations, so unless we could tell the client "_hey, you are the lucky one to make the first request; please wait while we get our s\*\*t together_", we needed to find another way. It is the right idea, but we need a better implementation.
  
  We want to decouple the CB initialization from the request thread, and if at any time during the request we find CB connection not initialized, we start the initialization process on a separate thread while immediately failing the CB request. We also want to attempt initialization during the application startup, on a separate thread of course, which if successful, means that the first request will find a CB connection ready to be used. However, if the initialization fails during the startup, we do not want hundreds or thousands of subsequent requests to flood the CB server; we need to throttle the traffic, as well as put a sleep time between failures, should there be any. We need _Hystrix_.

  Good thing is that the CB [Java client SDK](https://github.com/couchbase/couchbase-java-client) fully supports RxJava, and so does Hystrix, so they fit like peas in a pod.

  Last but not the least, since cluster and bucket opening are expensive operations, we cache the values once successful.

* **Degraded Response**

  I already touched upon this in the previous section. If at any time during the request we find CB connection not initialized, we immediately fail the CB request. The client handles the exception, and returns a successful response without CB data. If, however, CB connection had been initialized but later dropped, then the CB request blocks until it times out. As long as the CB request timeout is less than the HTTP request timeout, the caller receives a slightly delayed, but successful response.

* **Client Reconnection**

  Connection attempts if none had succeeded so far has been discussed in the startup section. Continuing on the previous section, reconnection after a successful connection had been established but later dropped is handled by CB SDK. This is also related to the following section, because when a CB node is restarted, it's IP may very well change. The default CB client (and server) behavior is to use IPs for nodes, but in K8S, that does not work because of the aforementioned reason. We need to use DNS names that do not change with node restarts. We will see later how to implement this in K8S.

* **CB Server Node Restart**

  Discussed in the previous section.

## Implementation

### CB Client

As previously mentioned, we use RxJava all the way. It makes a crucial difference between this approach and any other by introducing _delayed execution_. I dare say, as of this writing, no other solution exists publicly that employs this technique, and thus, is robust enough to handle CB connection failure at startup. My code uses a `Single<AsyncCluster>` and `Single<AsyncBucket>`, so we can delay the execution until subscription. I use the [factory pattern](https://en.wikipedia.org/wiki/Factory_(object-oriented_programming)) to encapsulate the gory details of bootstrap and bucket opening. Using RxJava also allows me to declaratively spawn new threads, and handle failures gracefully.

> "Talk is cheap. Show me the code" - Linus Torvalds.

The lynchpin of this solution are three classes, [CouchbaseAsyncClusterFactory](https://github.com/asarkar/spring/blob/master/beer-demo/couchbase-lib/src/main/java/org/abhijitsarkar/spring/beer/factory/CouchbaseAsyncClusterFactory.java), [CouchbaseAsyncBucketFactory](https://github.com/asarkar/spring/blob/master/beer-demo/couchbase-lib/src/main/java/org/abhijitsarkar/spring/beer/factory/CouchbaseAsyncBucketFactory.java), and [AsyncBucketHystrixObservableCommand](https://github.com/asarkar/spring/blob/master/beer-demo/couchbase-lib/src/main/java/org/abhijitsarkar/spring/beer/factory/AsyncBucketHystrixObservableCommand.java). Technically, the first two are `interface`, with default implementations provided in the same Java files. The factory classes are singleton Spring beans that each store references to a `Single<AsyncCluster>` and `Single<AsyncBucket>`, respective to their names. The Hystrix command is responsible for opening the bucket, optionally creating it if does not already exist as well as creating a primary index, and controlling the access to the bucket creation/opening logic through a semaphore. I strongly encourage you to take a look before proceeding: The code speaks for itself, I hope, and there are ample comments in the Hystrix command.

I also called upon the [Repository](https://msdn.microsoft.com/en-us/library/ff649690.aspx) design pattern, and created a [CouchbaseRepository](https://github.com/asarkar/spring/blob/master/beer-demo/couchbase-lib/src/main/java/org/abhijitsarkar/spring/beer/repository/CouchbaseRepository.java) interface, and a [BaseCouchbaseRepository](https://github.com/asarkar/spring/blob/master/beer-demo/couchbase-lib/src/main/java/org/abhijitsarkar/spring/beer/repository/BaseCouchbaseRepository.java) `abstract` class extending from it. Client code is usually expected to extend `BaseCouchbaseRepository`, and simply supply the generic type required. Of course, ambitious clients are free to implement `CouchbaseRepository`, or even use the factory classes directly. A sample `Repository` implementation is as follows, and it's beyond trivial.

```
@Repository
public class CouchbaseBeerRepository extends BaseCouchbaseRepository<Beer> {
}
```

That's it! The code using the `CouchbaseBeerRepository` looks like the following:

```
beerRepository.findOne(id)
    .map(ResponseEntity::ok)
    .onErrorReturn(t ->  ResponseEntity.status(INTERNAL_SERVER_ERROR).build())
    .timeout(TIMEOUT_MILLIS, MILLISECONDS)
    .toBlocking()
    .value()
```

The complete [CB client library](https://github.com/asarkar/spring/tree/master/beer-demo/couchbase-lib/src) code is on my GitHub, as well the [client app](https://github.com/asarkar/spring/tree/master/beer-demo/couchbase-client/src) that uses it.

{: .notice}
If you are using [Spring 5 WebFlux](https://docs.spring.io/spring/docs/5.0.1.RELEASE/spring-framework-reference/web-reactive.html#spring-webflux), you can go completely non-blocking and return a Reactive Streams [Publisher](https://github.com/reactive-streams/reactive-streams-jvm#1-publisher-code). That is a topic for another day.

{: .notice}
Couchbase Java client SDK has a [CouchbaseAsyncRepository](https://github.com/couchbase/couchbase-java-client/blob/master/src/main/java/com/couchbase/client/java/repository/CouchbaseAsyncRepository.java), but since it requires an `AsyncBucket` for instantiation, it was not useful to me.

{: .notice--warning}
If the CB cluster is not reachable during bootstrap, the CB SDK client goes crazy and keeps trying to connect to the server; the class that does this is `AbstractEndpoint` and as of this writing, there's no limit to how many times it tries before giving up. This is a felony offense if you ask me: It floods the logs with `java.net.ConnectException: Connection refused` errors. However, reconnection attempts after a successful connection had been established but later dropped can somewhat be configured using the [client settings](https://developer.couchbase.com/documentation/server/current/sdk/java/client-settings.html).

### CB Server

Official [Couchbase Docker image](https://hub.docker.com/r/couchbase/server/) requires manual set up, thus I created [my own image](https://github.com/asarkar/docker/tree/master/couchbase) that initializes an one-node cluster out of the box. It is available on Docker Hub as `asarkar/couchbase`. In order to make it work on K8S, we must set the node [hostname](https://developer.couchbase.com/documentation/server/current/install/hostnames.html) to a DNS name, not IP. By doing so, when the node is restarted, the hostname does not change even though the IP may. To achieve this, we use a [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/), along with a [Headless service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services). `StatefulSet` gives us predetermined `Pod` names, and when used with a Headless service, each node gets a network identity in the form of `$(statefulset name)-$(ordinal).$(service name).$(namespace).svc.cluster.local`, which is what we use for hostname. The service itself gets a DNS name `$(service name).$(namespace).svc.cluster.local` that resolves to a list of all the nodes. Refer to the `StatefulSet` and Headless service docs, as well as the [K8S DNS](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/) docs for further details.

However, the above is not all. If we stop here, the CB client would be given the service DNS name, which in turn would resolve to the `Pods` during bootstrap. That does not work for two reasons:

1. For high availability, the CB client SDK usually expects a list of nodes, not a single node.

2. The "smart" client, as they call it, establishes a fully-connected mesh network with the CB server nodes. Depending on what services are running on which nodes, and how the data is replicated, the client makes the decision which node to talk to. Putting a service in front of the nodes completely breaks this process.

Luckily, there is something called [DNS SRV Record](https://en.wikipedia.org/wiki/SRV_record). Quoting K8S docs:

> For each named port, the SRV record would have the form `_my-port-name._my-port-protocol.my-svc.my-namespace.svc.cluster.local` ... For a headless service, this resolves to multiple answers, one for each pod that is backing the service

And from CB docs for [Managing Connections](https://developer.couchbase.com/documentation/server/current/sdk/java/managing-connections.html), we come to know that the CB client can be configured to bootstrap with a DNS SRV Record in the form of `_couchbase._tcp.example.com`. Connecting the dots, if we name one of the exposed ports on the service `couchbase`, and provide the client with a  name `cb-svc.my-namespace.svc.cluster.local`, we are golden!

{: .notice--info}
I initially assumed that the prefix `couchbase` was only an example, and could be any string as long as the FQN is a DNS SRV name. That is not the case; it is not at all difficult to make it configurable in the [CouchbaseEnvironment](https://github.com/couchbase/couchbase-java-client/blob/master/src/main/java/com/couchbase/client/java/env/CouchbaseEnvironment.java), but the CB guys decided to hard code the `couchbase` prefix instead.

{: .notice--info}
If the CB client is running in the same K8S namespace, only `cb-svc` can be used without requiring the FQN.

Last but not the least, data persistence. After all, what good is a database that cannot persist data? Luckily, `StatefulSet` has first-class support for [Stable Storage](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#stable-storage). Since we are running a single-node CB cluster on a dedicated K8S node, we chose to go with a [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath). We did try [GlusterFS](https://www.gluster.org/) once, but it did not perform well under load, and we did not see the return on investment in fine-tuning it. In the future, if we loosen the restriction to run CB on a single K8S node, we can easily repopulate the data in a short time. For the period the data would not be available, the client would continue to return a degraded response.

My GitHub CB project contains the K8S [manifests](https://github.com/asarkar/docker/tree/master/couchbase/k8s). You can use those to run locally on [Minikube](https://github.com/kubernetes/minikube), or on any other cluster.

{: .notice--warning}
There is a gotcha is with configuring the K8S Liveliness and Readiness Probes. We implemented the former as a simple probe of the 8091 port (here is a list of all CB [ports](https://developer.couchbase.com/documentation/server/current/install/install-ports.html)). Implementing a smart probe for readiness, like checking the cluster status or something similar, ran into a problem where CB tries to contact all the nodes for determining cluster status, and until the readiness probe succeeds, K8S does not create a DNS entry for the node, thus resulting in a catch-22 situation. Thus, we did not implement a custom readiness probe.

## Conclusion

Like I mentioned in the beginning, CB does not officially support running on K8S. They say they are [working on it](https://blog.couchbase.com/couchbase-openshift-enterprise-kubernetes-developer-preview-available/), but not much details have been made available. There also exists an [official blog](https://blog.couchbase.com/couchbase-on-kubernetes/), but it falls short of addressing the issues discussed in this article. In order to be a first-class K8S citizen, CB has to support effortless scaling up and down, which means adding and removing nodes without the need for manual intervention, and step up their failover game. Data replication/migration when nodes are added or removed also needs to be handled transparent to the clients.
While time will tell the future of CB server on K8S, I do not see why, with some effort, the client solution here cannot be incorporated in the CB Java client SDK; I intend to approach them with that proposal, such that other people can also benefit from my effort and learning.
