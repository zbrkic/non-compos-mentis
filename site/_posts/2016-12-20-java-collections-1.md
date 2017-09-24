---
title: "What's Wrong with Java Collections - part I"
excerpt: "Shortcomings of the Java Collections Framework."
categories: Technical
tags: [technical, java, collections, design]
---

Java 1.2 introduced the Collections framework that standardized how developers would manage groups of objects in their code. From the Java SE [tutorial](http://docs.oracle.com/javase/tutorial/collections/intro/index.html):

> A collection — sometimes called a container — is simply an object that groups multiple elements into a single unit. Collections are used to store, retrieve, manipulate, and communicate aggregate data.

{: .notice--info}

Here onwards, I'm going to use the word "collection" to refer to a logical group of things represented by the "the Collections framework" in Java. If I need to refer to the `java.util.Collection` interface or the `java.util.Collections` utility class, I'll use the simple class name, with a capital 'C', and style the word differently.

Java 1.5 (rebranded as Java SE 5) introduced generics which provided compile time type safety to collections. However,
the collections is not all it's cracked up to be. In this series of articles, I'll explore the various design
issues with the collections.

1. **`Map` is not a `Collection`**

   The [official docs](https://docs.oracle.com/javase/8/docs/technotes/guides/collections/overview.html) say:

   > ...interfaces...based on `java.util.Map`...are not true collections. However, these interfaces
   contain collection-view operations...

   Consider a use case where you need to extract HTTP request headers that start with a certain prefix.
   The `HttpServletRequest` doesn't have any methods to return a header map, only a hideous
   `Enumeration getHeaderNames` (why Java, why?). Let's take a better abstraction from the Spring Web MVC
   framework, one of the most popular application frameworks for the Java platform. In Spring, you can get a `HttpHeaders`
   which is basically a wrapper around a `Map<String,List<String>>`.
   Using Java 8, and some static imports, the code for our use case may look like the following:

   ```
   headers.keySet()
       .stream()
       .filter(k -> k.startsWith(prefix))
       .collect(toMap(Function::identity, headers::get));
   ```
   While the above works, all we really care about is the `filter` operation. The rest of the code is just a means to
   an end. If this looks verbose to you, try implementing this in pre Java 8.

   Now let's try to do the same thing using the class `Headers` from the Play framework, another popular web
   application framework, and with Scala. There is a method `toMap` in `Headers` trait that returns a
   `Map[String, Seq[String]]`. `Map` trait in Scala extends `Traversable` which has a `filter` method. Thus:

   ```
   request.headers
       .toMap
       .filter(_.startsWith(prefix))
   ```

   {: .notice--info}

   I have taken the liberty to use some Scala [syntactic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar)
   (I love dropping buzzwords to programmers working with imperative languages because they go like, "wow,
   that's so cool, can I buy you a drink?").

   You don't need to know Scala in order to appreciate the simplicity of the second solution. A map is nothing but
   a collection of key-value pairs. Why did they not add a `stream` method in the `Map` interface with Java 8 is beyond me.

   You can get pretty darn close to the Scala solution using the excellent [Javaslang](http://www.javaslang.io/) library:

   ```
   HashMap.<String, List<String>>ofAll(httpHeaders)
       .filter((k, v) -> k.startsWith(prefix));
   ```

   {: .notice--info}

   Javaslang has a `Multimap` interface but none of its implementations has a method to start from a `java.util.Map`,
   so I'm using a `HashMap<String, List<String>>` I've ticket [1767](https://github.com/javaslang/javaslang/issues/1767) open for this on their Github.

2. **`String` is not a `Collection`**

   Let's see some code that drops characters other than the vowels from a string.

   ```
   String s = "alice";

   s.chars()
       .filter(this::isVowel)
       .mapToObj(i -> (char)i)
       .collect(joining());
   ```
   where `isVowel` simply checks against a predefined list of integers (ASCII code for vowels, upper and lower cases).

   The Scala solution is trivial:

   ```
   s.filter(isVowel)
   ```

   Javaslang:

   ```
   CharSeq.of(s)
       .filter(this::isVowel)
       .toString();
   ```

   Too easy? I thought so. Let's consider another example where you need to calculate the [run-length encoding](https://en.wikipedia.org/wiki/Run-length_encoding) of the characters. The output should be a list of tuples. For examples, given the word "bookkeeper", the output should be a collection with the pairs (b, 1), (o, 2), (k, 2), (e, 2), (p, 1), (e, 1), (r, 1).

   I'll implement the Javaslang and Scala solutions but will leave the Java 8 solution as a challenge for you. For a pre Java 8 solution, although not exactly in the same format as asked for here, see [this](https://www.rosettacode.org/wiki/Run-length_encoding#Java).

   {: .notice--info}

   Hint: Look at [Collector](https://docs.oracle.com/javase/8/docs/api/java/util/stream/Collector.html).

   Scala:

   ```
   def rle(s: String) = {
       val packed = s.foldLeft(('\u0000', 0, Seq.empty[(Char, Int)])) {(acc, elem) =>
           if (elem == acc._1 || acc._2 == 0) // keeps accumulating dupes
               (elem, acc._2 + 1, acc._3)
           else // adds accumulated dupes to result and starts new dupes accumulator
               (elem, 1, acc._3 :+ (acc._1, acc._2))
       }

       packed._3 :+ (packed._1, packed._2) // adds last one
   }
   ```

   Javaslang:

   ```
   public List<Tuple2<Character, Integer>> rle(String s) {
       Tuple3<Character, Integer, List<Tuple2<Character, Integer>>> zero =
               new Tuple3<>('\u0000', 0, new ArrayList<Tuple2<Character, Integer>>());
       Tuple3<Character, Integer, List<Tuple2<Character, Integer>>> packed = CharSeq.of(s)
               .foldLeft(zero, (acc, elem) -> {
                   if (elem == acc._1 || acc._2 == 0) {
                       return new Tuple3(elem, acc._2 + 1, acc._3);
                   } else {
                       acc._3.add(new Tuple2(acc._1, acc._2));
                       return new Tuple3(elem, 1, acc._3);
                  }
               });

       packed._3.add(new Tuple2(packed._1, packed._2));

       return packed._3;
   }
   ```

   Again, Javaslang follows on the heels of the Scala solution within the limitations of the language.

   {: .notice--warning}

   In the code samples above, adding an item to the end can be highly expensive for large collections. Sadly, a detail discussion of performance optimization of various collection operations is out of the scope for this article.

   The examples above may be contrived but that's not my point. `String` really is a collection of characters;
   it in fact, implements `CharSequence`. Why does it not implement `Collection` then? You will have to ask the JDK designers. Luckily, all is not lost; the `chars` method allows for a `String` to be treated like a `Collection`.

In the second part of this series, I will discuss some other design problems of the collections.
