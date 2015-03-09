---
layout: post
title:  "Gradle: 'provided' Dependency Scope"
date:   2015-02-18 21:00:00
category: dev
tags: gradle
comments: True
---
Maven's ["provided" dependencies](http://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html#Dependency_Scope) are available for compilation and for test execution, but won't be put on the runtime classpath and won't be packaged. But unlike Maven, [Gradle doesn't support a "provided" dependency scope](https://issues.gradle.org/browse/GRADLE-784) out-of-the-box.

Defining a "provided" scope in Gradle is pretty straight-forward, but it is not exactly a one-liner: You have to define a new configuration and add it to the various classpathes.

{% highlight groovy %}
configurations {
  provided
}

sourceSets {
  main {
    compileClasspath += configurations.provided
  }
  test {
    compileClasspath += configurations.provided
    runtimeClasspath += configurations.provided
  }
}

dependencies {
  provided "javax:j2ee:1.3.1" // example
}
{% endhighlight %}

If you are using Gradle's [Eclipse](http://gradle.org/docs/current/userguide/eclipse_plugin.html) or [IDEA support](http://gradle.org/docs/current/userguide/idea_plugin.html), you must also add the configuration to the classpath of these modules:

{% highlight groovy %}
eclipse {
  classpath {
    plusConfigurations += [configurations.provided]
    noExportConfigurations += [configurations.provided]
  }
}

idea {
  module {
    scopes.PROVIDED.plus += [configurations.provided]
  }
}
{% endhighlight %}
