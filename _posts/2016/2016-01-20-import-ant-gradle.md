---
layout:     post
title:      "Gradle: Importing an Ant Build"
category: dev
tags: ant gradle
comments: true
---
Some quick code snippets for [using an Ant build script from within a Gradle build](https://docs.gradle.org/current/userguide/ant.html):

## Plain and simple

Make all Ant targets available as Gradle tasks:

{% highlight groovy %}
ant.importBuild("build.xml")
{% endhighlight %}

## Conflicting target names

If the Ant script contains a target that conflicts with a Gradle task, a simple import will fail. With an optional configuration closure, it is possible to rename the Ant target on import:

{% highlight groovy %}
ant.importBuild("build.xml", { targetName ->
  targetName == "clean" ? "ant.clean" : targetName
})
clean.dependsOn("ant.clean")
{% endhighlight %}

## Optional Ant tasks

If the Ant script uses [optional tasks](https://ant.apache.org/manual/install.html#optionalTasks), these tasks must explicitly be defined, and the implementing libraries must be added as dependencies.
In this example, I am using JUnit 4.8.2 with the Ant-provided `junit` and `junitreport` tasks:

{% highlight groovy %}
configurations {
  antLibs
}

ant.antversion(property: "_antversion")
ext.antVersion = ant.properties["_antversion"]

dependencies {
  antLibs("junit:junit:4.8.2")
  antLibs("org.apache.ant:ant-junit:$antVersion")
  antLibs("org.apache.ant:ant-junit4:$antVersion")
}

ant.taskdef(name: "junit",
    classname: "org.apache.tools.ant.taskdefs.optional.junit.JUnitTask",
    classpath: configurations.antLibs.asPath)
ant.taskdef(name: "junitreport",
    classname: "org.apache.tools.ant.taskdefs.optional.junit.XMLResultAggregator",
    classpath: configurations.antLibs.asPath)

ant.importBuild("build.xml")
{% endhighlight %}

Tested with [Gradle 2.2](https://docs.gradle.org/2.2/release-notes.html) and [Ant 1.9.3](http://ant.apache.org/)
