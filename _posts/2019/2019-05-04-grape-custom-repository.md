---
layout:   post
title:    "Using Grape with a custom repository server"
category: dev
tags:     groovy
comments: true
---
[Grape](http://www.groovy-lang.org/Grape) is a great thing if you want to write a Groovy script that depends on a third party library:
Just add `@Grab('groupid:artifactid:version')` on top of your script, and the specified Maven artifact will be downloaded and is available at runtime.

However, if you are forced to use a different repository server (like a private Artifactory or Nexus service), the documentation is not very exhaustive.

Grape uses [Ivy](https://ant.apache.org/ivy/) behind the scenes, so the key is to provide your own [custom Ivy settings](http://docs.groovy-lang.org/latest/html/documentation/grape.html#Grape-CustomizeIvysettings) in a file called ` ~/.groovy/grapeConfig.xml`. In the following example, Grape will use a Maven repository located at `http://artifactory.local/libs-release` to download artifacts:

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<ivysettings>
  <settings defaultResolver="downloadGrapes"/>
  <resolvers>
    <chain name="downloadGrapes" returnFirst="true">
      <ibiblio name="artifactory" m2compatible="true" root="http://artifactory.local/libs-release"/>
    </chain>
  </resolvers>
</ivysettings>
{% endhighlight %}

(This example is a stripped-down version of the [default Grapes settings](https://github.com/apache/groovy/blob/master/src/resources/groovy/grape/defaultGrapeConfig.xml))