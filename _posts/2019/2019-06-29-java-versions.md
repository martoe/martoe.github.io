---
layout:   post
excerpt_separator: <!--more-->
title:    "What's New in Java X?"
category: dev
tags:     java
comments: true
---
Since Java switch from a (kind of) 3-years feature release cycle to 6 months, it is hard for me to track the most important changes.
This cheat-sheet shall help me to quickly pick the right Java version.
For an extensive list see e.g. [Wikipedia](https://en.wikipedia.org/wiki/Java_version_history).

<!--more-->

This lists just the most important changes (from my point of view):

# Java 12 (2019)

* Switch expressions (preview)
{% highlight java %}
    String result = switch (new Random().nextInt(3)) {
        case 0 -> "zero";
        case 1 -> "one";
        case 2 -> "two";
        default -> "impossible";
    };
{% endhighlight %}
* Microbenchmark suite

[Exhaustive feature list](https://www.azul.com/39-new-features-and-apis-in-jdk-12/). See also [Java 12: New Features](https://stackify.com/java-12-new-features-and-enhancements-developers-should-know/)

# Java 11 (2018 - LTS)

* HTTP Client API (now standard)
* Launch single-file programs without explicit compilation: `java HelloWorld.java`
* Launch single-file programs with shebang (note that the file must *not* end with ".java"):

{% highlight java %}
    #!/usr/bin/java --source 11
    public class HelloWorld {
      public static void main(String[] args) {
        System.out.println("Hello World");
      }
    }
{% endhighlight %}

* Removal of JavaEE packages: JAX-WS, JAXB, JAF, JTA, Common annotations (`@Resource`...)
* Removal of CORBA
* Removal of JavaFX

[Exhaustive feature list](https://www.azul.com/90-new-features-and-apis-in-jdk-11/)

# Java 10 (2018)

* Local variable type inference - the `var` keyword
* Docker container awareness (for calculating memory and CPU resources)

[Exhaustive feature list](https://www.azul.com/109-new-features-in-jdk-10/). See also [What's new in Java 10](https://stackify.com/whats-new-in-java-10/), [Guide to Java 10](https://www.baeldung.com/java-10-overview).

# Java 9 (2017)

* Java modules (aka Project Jigsaw)
* HTTP Client API (incubation)
* Process API
* Private methods in interfaces
* JShell (read-evaluate-print loop)
* Multi-release jar files
* G1 (Garbage First) garbage collector is now default

[Exhaustive feature list](https://de.slideshare.net/SimonRitter/55-new-features-in-jdk-9). See also [Java 9 New Features](https://www.baeldung.com/new-java-9).

# Java 8 (2014 - LTS)

* Lambda expressions, functional interfaces
* Method references (e.g. `String::toUppercase`)
* Stream API
* Default and static methods on interfaces
* `Optional` type
* DateTime API

[Exhaustive feature list](https://www.oracle.com/technetwork/java/javase/8-whats-new-2157071.html). See also [Java 9 New Features](https://www.baeldung.com/java-8-new-features).
