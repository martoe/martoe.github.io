---
layout:   post
title:    "Request Tracing with JBoss 7"
category: dev
tags:     jboss
comments: true
---
To log HTTP requests and responses with JBoss 7, activate the `RequestDumperValve` and enable the `org.apache.catalina.core.ContainerBase` logging category.
Here are the relevant excerpts from `standalone.xml`:

{% highlight xml %}
[...]
<subsystem xmlns="urn:jboss:domain:logging:1.3">
  [...]
  <logger category="org.apache.catalina.core.ContainerBase">
    <level name="INFO" />
  </logger>
  [...]
</subsystem>
[...]
<subsystem xmlns="urn:jboss:domain:web:1.5">
  [...]
  <valve name="RequestLogging" module="org.jboss.as.web" class-name="org.apache.catalina.valves.RequestDumperValve"/>
</subsystem>
[...]
{% endhighlight %}

References: [JBossWeb](https://docs.jboss.org/jbossweb/7.0.x/config/valve.html), [Stackoverflow](http://stackoverflow.com/a/14161001)
