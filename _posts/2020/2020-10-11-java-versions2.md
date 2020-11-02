---
layout:   post
excerpt_separator: <!--more-->
title:    "What's New in Java 13/14/15?"
category: dev
tags:     java
comments: true
---
A year has passed since the last post [Java 8-12]({{ site.baseurl }}{% post_url 2019-06-29-java-versions %}),
three new Java versions have been released, but no big news from a developer's perspective...

<!--more-->

# Java 13 (2019)

* Switch expressions: `yield` statement (preview)
* Text blocks (multi-line strings like in [Groovy](https://groovy-lang.org/syntax.html#_triple_double_quoted_string) - preview)

[Exhaustive feature list](https://www.azul.com/81-new-features-and-apis-in-jdk-13/). See also [Java 13: New Features](https://www.baeldung.com/java-13-new-features)

# Java 14 (2020)

* Pattern matching of `instanceof` 

{% highlight java %}
    Object obj = /* ...*/
    if (obj instanceof Person p) {
        p.getLastName(); // look ma, no cast!
    }
{% endhighlight %}

* Records - pure data classes without boilerplate code (preview)

{% highlight java %}
    record Person (String firstName, String lastName, Date dateOfBirth) {
    }
{% endhighlight %}

* Text blocks extended (preview)

[Exhaustive feature list](https://www.azul.com/whats-new-in-jdk14-latest-release/). See also [Java 14: New Features](https://www.journaldev.com/37273/java-14-features)

# Java 15 (2020)

* Sealed classes (preview) - restrict which classes may extend a given class
* Hidden classes - useful for classes generated at runtime
* Nashorn JavaScript Engine removed

[Exhaustive feature list](https://www.azul.com/jdk-15-release-64-new-features-and-apis/). See also [Java 15: New Features](https://www.techgeeknext.com/java/java15-features)
