---
title: "Spring Cloud Config Server - The Hidden Manual"
excerpt: "How to set up Spring Cloud Config Server with high availability, failover and dynamic update."
categories: Technical
tags: [technical, java, spring-cloud, microservice]
---

## Introduction

In 2015-2016, we redesigned a monolithic application into Microservices and chose the Spring Cloud Config for configuration
management.

Quoting the docs:

> Spring Cloud Config provides server and client-side support for externalized configuration in a distributed system.

To their credit, the Spring Cloud Config [documentation](https://cloud.spring.io/spring-cloud-config/) is fairly good, but it
doesn't go into the level of detail I was looking for. This post attempts to bridge that gap. I assume some basic familiarity with Spring Cloud Config, so if you are new to it, come back after having read the official documentation. If working with Spring Cloud, you may also find my post [Spring Cloud Netflix Eureka - The Hidden Manual](../netflix-eureka) useful.

## Basic Architecture

The Config server is a Spring Boot application that is aware of the Spring `PropertySource` and `Environment` abstractions.
It serves properties in response to HTTP requests. It can also serve plain text files, thus acting like a simple Web Server.
I'm not going to repeat what's already specified in the official docs, so let's move on to what's not mentioned there.

> When reading config files from sub-directories, if more than one directory has files with identical names, the last one wins. I haven't checked but would assume similar behavior for multiple Git repos as well. The question I've, and didn't get time to look into, is what makes a `PropertySource` for config server? Is it an application, a Spring profile, a Git repo, a label, or some combination of these?

## Failover

In spite of the built-in intelligence, Config server is pretty dumb in some cases. It doesn't have any caching
mechanism, although properties are fairly easy to cache, and as of this writing, it doesn't have first class support
for failover, as well. Depending on the backing property store, it either goes to the file system for every request, or
pulls from Git. The former is not that bad, even though caching would obviously help, but the latter could be an issue
if connection to Git is slow or the repo is somewhat large. Ticket [#566](https://github.com/spring-cloud/spring-cloud-config/issues/566) complains about the last point.

Lack of failover is a bigger concern. Assuming the backing property store is a Git repo, if Config loses connectivity to Git, or for some other reason, fails to clone the repo, it fails the request. This is a problem for Singleton beans that attempt to fetch properties at startup, because the application fails to start up.
There are few tickets opened to address this, notably [#617](https://github.com/spring-cloud/spring-cloud-config/issues/617) and [#631](https://github.com/spring-cloud/spring-cloud-config/issues/631). While Spring works towards providing first class
support for failover, I submitted a [pull request](https://github.com/spring-cloud/spring-cloud-config/pull/634) to make `JGitEnvironmentRepository#refresh` method `public`, which is
the one that does the cloning. If `refresh` is made `public`, then Config server could be enhanced using Spring AOP to
handle failover. How, depends on your use case and design. One option is to return stale properties from the local repo if `refresh` fails. Another option is to return cached properties. Multiple Git repos could be configured as well, although in that case,
keeping them in sync would become another challenge.

## High Availability

Unlike Eureka, Config server doesn't have a concept of peers. Thus, if you are serving properties from native file system,
the simplest option is to use a shared file system. You can them employ the usual techniques against hard disk failures
to provide high availability. If you are using Git, the simplest solution is to put Config server behind a load balancer,
or if using a container orchestration solution like Kubernetes, set up a Kubernetes service. The actual number of
Config server instances is then abstracted from the clients who only see the load balancer (physical or Kubernetes) URL.

If you expect that the config server may be temporarily unavailable when your client app starts, you can ask it to keep trying after a failure. First you need to set `spring.cloud.config.failFast=true`, and then you need to add `spring-retry` and `spring-boot-starter-aop` to your classpath. See the official docs for details. As of this writing, there is no server-side retry, although it wouldn't be very difficult to add that using AOP or by submitting a pull request.

## Dynamic Update

It's possible to dynamically update the properties without having to restart Config server or the client apps using Git
webhooks and Spring Cloud Bus. It requires a broker as the transport, and as of this writing, only RabbitMQ and Kafka are
supported. You need to add `spring-cloud-config-monitor` to the Config server, and a broker implementation like
`spring-cloud-starter-bus-kafka` to both the server and the client. Then you need to set up Git webhooks for the `/monitor`
endpoint, that's brought in by the `spring-cloud-config-monitor`. I've tried this implementation using Kafka, and it worked,
but in our case, deploying and maintaining a queue for dynamic updates that's going to be quite infrequent couldn't be justified. Unfortunately, the monitor endpoint is tightly coupled with Spring Cloud Bus and it's not possible to reuse the controller and the parsing of the events, but to choose how to react to the push notifications. I've
opened ticket [#628](https://github.com/spring-cloud/spring-cloud-config/issues/628) to address this, although I don't expect them to fix it anytime soon.

I ended up copying the monitor endpoint implementation from Spring. Then I pimped the Config server to fetch the list of all pods from Kubernetes, and send a HTTP POST to each one on the `/refresh` endpoint provided by Spring Boot Actuator. I used the `KubernetesClient` from the `io.fabric8:kubernetes-client` project for retrieving the list of pods. The actual code handles some advanced cases like rolling update and retries, but the theory behind it is as explained above and not complicated. The technique I used is similar to this [example](https://github.com/asarkar/java/blob/master/concurrency-learning/src/main/java/org/abhijitsarkar/reactor/GroupsAndDelays.java), and yes, the solution is fully [reactive](http://www.reactivemanifesto.org/) within the limits of current Spring framework.

Config server is not the only choice though: [Netflix Archaius](https://github.com/Netflix/archaius), [Apache ZooKeeper](https://zookeeper.apache.org/) and [Kubernetes ConfigMap](https://kubernetes.io/docs/user-guide/configmap/) also provide configuration management, although none is aware of Spring `PropertySource` and `Environment` abstractions out of the box. In the end, Config server is a good choice if you are willing to put in some time to make it more robust.
