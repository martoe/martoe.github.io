---
layout: post
title:  "Title"
date:   2015-01-01 00:00:00
categories: ci gradle jenkins maven
---
Markdown contents

{% highlight groovy %}
apply plugin: "groovy"
apply plugin: "eclipse"

tasks.withType(JavaCompile) { // old Gradle versions use type "Compile"
  options.encoding = "UTF-8"
}

eclipseJdt << {
  file(".settings/org.eclipse.core.resources.prefs").text = "eclipse.preferences.version=1\nencoding/<project>=UTF-8"
}
{% endhighlight %}

[set the file encoding in Eclipse](https://issues.gradle.org/browse/GRADLE-1010?focusedCommentId=15225&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-15225)
