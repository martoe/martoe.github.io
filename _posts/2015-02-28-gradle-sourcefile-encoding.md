---
layout: post
title:  "Sourcefile Encoding with Gradle"
date:   2015-02-28 20:00:00
categories: dev
tags: gradle
comments: True
---
Source file encoding is another example of a tiny problem that needs a surprisingly big amount of Gradle code.
There is a [pretty old issue](https://issues.gradle.org/browse/GRADLE-1010) for this, so if you think that the code below is too complicated (like I do), please vote for it.

## Java files

Gradle uses the [platform encoding as default](http://gradle.org/docs/current/dsl/org.gradle.api.tasks.compile.CompileOptions.html#org.gradle.api.tasks.compile.CompileOptions:encoding) encoding for Java files (like the Java compiler does), which is a bad choice for platform-independent applications. To change this, add the following snipplet to your `build.gradle` file:
{% highlight groovy %}
apply plugin: "java"
tasks.withType(JavaCompile) {
  options.encoding = "UTF-8"
}
{% endhighlight %}
This is because we have at least two instances of a [`JavaCompile`](http://gradle.org/docs/current/javadoc/org/gradle/api/tasks/compile/JavaCompile.html) task ("compileJava" and "compileTestJava"), and the encoding must be applied to all of them.
Note that early versions of Gradle use type [`Compile`](https://gradle.org/docs/1.1/javadoc/org/gradle/api/tasks/compile/Compile.html) instead.

## Groovy files

[`GroovyCompile`](http://gradle.org/docs/current/javadoc/org/gradle/api/tasks/compile/GroovyCompile.html) tasks have different encoding settings for Java and Groovy files:
{% highlight groovy %}
apply plugin: "groovy"
tasks.withType(GroovyCompile) {
  options.encoding = "UTF-8" // for Java compilation
  groovyOptions.encoding = "UTF-8" // for Groovy compilation
}
{% endhighlight %}
In the current case, the `groovyOptions.encoding` line is optional, since UTF-8 is the default encoding for Groovy files.

## Eclipse integration

The [Eclipse Plugin](http://gradle.org/docs/current/userguide/eclipse_plugin.html) ignores the encoding settings, so we must create the corresponding configuration file manually, as documented in the [issue mentioned above](https://issues.gradle.org/browse/GRADLE-1010?focusedCommentId=15225&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-15225):
{% highlight groovy %}
apply plugin: "eclipse"
eclipseJdt << {
  file(".settings/org.eclipse.core.resources.prefs").text
      = "eclipse.preferences.version=1\nencoding/<project>=UTF-8"
}
{% endhighlight %}

## Intellij IDEA integration

Again, no out-of-the-box encoding support with the [IDEA plugin](http://gradle.org/docs/current/userguide/idea_plugin.html). We must add a new XML node to the XML project file:
{% highlight groovy %}
apply plugin: "idea"
idea {
  project {
    ipr {
      withXml { xmlProvider ->
        def encoding = xmlProvider.asNode().component.find { it.@name == "Encoding" }
        encoding.appendNode("file", [url: "PROJECT", charset: "UTF-8"])
      }
    }
  }
}
{% endhighlight %}
The sample code is based on this [Gradle goodness posting](http://mrhaki.blogspot.co.at/2012/09/gradle-goodness-customize-idea-project.html) and tested with IDEA 14.
