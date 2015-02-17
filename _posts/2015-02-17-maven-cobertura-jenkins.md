---
layout: post
title:  Integrating Maven and Cobertura with Jenkins
date:   2015-02-17 20:00:00
categories: maven jenkins ci
---
After serveral happy years without Maven, I am again confronted with a complex multi-module Maven build.
 My task is to create a simple Jenkins job that executes the unittests continuously, including a [Cobertura](http://cobertura.github.io/cobertura/) code coverage analysis.

Surprisingly, there haven't been any big changes neither to Maven nor to Cobertura within the last years
- but still it took me some time of trying and googling to be sure that there is no beautiful solution for this rather simple task
(the "documentation" of the [Cobertura Maven Plugin](http://mojo.codehaus.org/cobertura-maven-plugin/) is no big help)

My first try is a straight forward `mvn install cobertura:cobertura`, which basically works,
and the [Jenkins Cobertura Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Cobertura+Plugin) displays the expected results.
The downside of this is that since the [Maven Cobertura Plugin](http://mojo.codehaus.org/cobertura-maven-plugin/) uses its own lifecycle
(which basically instruments the code, executes the tests, and generates the report),
this causes all tests to be executed twice, which is not acceptable for my current project.

`mvn -DskipTests install cobertura:cobertura` doesn't work as it skips the tests for both targets.
`mvn cobertura:cobertura` works well with Maven 3 (which can resolve submodule dependencies without installing them to the local repo),
but sadly I am still stuck with Maven 2.

So in my case, the only solution is to run Maven twice:

    mvn -DskipTests install
    mvn cobertura:cobertura
