---
layout:   post
excerpt_separator: <!--more-->
title:    "What's New in Java 16/17?"
category: dev
tags:     java
comments: true
---
Previous posts:
* [Java 8-12]({{ site.baseurl }}{% post_url 2019-06-29-java-versions %})
* [Java 13-15]({{ site.baseurl }}{% post_url 2020-10-11-java-versions2 %})

<!--more-->

# [Java 16](https://openjdk.java.net/projects/jdk/16/) (2021)

* The "[instanceof pattern matching](https://openjdk.java.net/jeps/394)" feature (from Java 14) is now final
* [Records](https://openjdk.java.net/jeps/395) (also a Java 14 preview) are now final
* a new incubating [Vector API](https://openjdk.java.net/jeps/338)

[Exhaustive feature list](https://blogs.oracle.com/java/post/the-arrival-of-java-16). See also [Java 16: New Features](https://www.infoq.com/articles/java-16-new-features/)

# [Java 17](https://openjdk.java.net/projects/jdk/17/) (2021 - LTS)

Java 17 itself brings only changes related to specialized use cases (like floating-point semantics or pseudo-random numbers), but no news for most developers.
But since most applications will upgrade straight from the last LTS, here are some important enhancements since Java 11, from a developer's perspective (excluding incubations and previews):

### [Switch expressions](https://openjdk.java.net/jeps/361)

* use the arrow syntax to avoid fall-through (without "break" statements), use colons for multiple values:
  {% highlight java %}
  switch (LocalDate.now().getDayOfWeek()) {
    case FRIDAY -> System.out.println("Today is almost weekend");
    case SATURDAY, SUNDAY -> {
      System.out.println("hurray!");
      System.out.println("Today is weekend");
    }
    default -> System.out.println("Today is working day");
  }
  {% endhighlight %}
 
* switch statements can be used as expressions (using the "yield" statement if blocks are necessary):
  {% highlight java %}
  var dayType = switch (LocalDate.now().getDayOfWeek()) {
    case FRIDAY -> "almost weekend";
    case SATURDAY, SUNDAY -> {
      System.out.println("hurray!");
      yield "weekend";
    }
    default -> "working day";
  };
  System.out.println("Today is " + dayType);
  {% endhighlight %}

* "yield" can also be used in traditional switch syntax: 
  {% highlight java %}
  var dayType = switch (LocalDate.now().getDayOfWeek()) {
    case FRIDAY:
      yield "almost weekend";
    case SATURDAY, SUNDAY:
      System.out.println("hurray!");
      yield "weekend";
    default:
      yield "working day";
  };
  System.out.println("Today is " + dayType);
  {% endhighlight %}

* No "default" block is required if enum values are exhaustive:
  {% highlight java %}
  var dayType = switch (LocalDate.now().getDayOfWeek()) {
    case FRIDAY -> "almost weekend";
    case SATURDAY, SUNDAY -> "weekend";
    case MONDAY, TUESDAY, WEDNESDAY, THURSDAY -> "working day";
  };
  System.out.println("Today is " + dayType);
  {% endhighlight %}

### [Text blocks](https://openjdk.java.net/jeps/378)

* A text block starts with a tripple doublequote, followed by a newline
* the line with the smallest indentation determines how many leading chars are ignored for each line ("tab" counts as one char) 

{% highlight java %}
System.out.println("""
   First line, 3 blanks = 1 char indentation
  Second line, 2 blanks = no indentation

			Forth line, 3 tabs = 1 tab indentation""");
{% endhighlight %}

### [Pattern Matching for instanceof](https://openjdk.java.net/jeps/394)

* declare a variable as part of the "instanceof" operator to avoid a cast

{% highlight java %}
Object value = /* some arbitrary object */
if (value instanceof Number x) {
  System.out.println(x.doubleValue());
} else if (value instanceof String x) {
  System.out.println(x.toUpperCase());
} else {
  System.out.println(value);
}
{% endhighlight %}

### [Records](https://openjdk.java.net/jeps/395)

* Records are immutable objects (aka "value objects") that provide a constructor, getters, an "equals()" implementation (that compares all fields) as well as "hashCode()" and "toString()" implementations
* The body of a record may define behaviour (i.e. instance methods) but must not define state (i.e. no instance variables)

{% highlight java %}
record Person(String firstName, String lastName) {
   //String address; // no instance fields allowed
   public String fullName() {
     return firstName + " " + lastName;
   }
}

var p1 = new Person("John", "Doe");
var p2 = new Person("John", "Doe");
assert p1 != p2;
assert p1.equals(p2);
assert p1.toString().equals("Person[firstName=John, lastName=Doe]");
{% endhighlight %}

### [Packaging tool](https://openjdk.java.net/jeps/392)

Creates an installation package (or a ready-to-use executable) for a jar file on the current operating system.

Example usage (for both installation package and executable):
```
jpackage --name java17app --input target --main-jar sample.jar --main-class my.package.MyMainClass
jpackage --name java17app --input target --main-jar sample.jar --main-class my.package.MyMainClass --type app-image
```
To create an installation package, additional software may be required on some platforms (e.g. [WiX](https://wixtoolset.org/) on Windows).
