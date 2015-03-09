---
layout: post
title:  "Technology Radar January 2015"
category: dev
comments: true
---
The [January 2015 issue](http://assets.thoughtworks.com/assets/technology-radar-jan-2015-en.pdf) of the [ThoughtWorks Technology Radar](http://www.thoughtworks.com/radar) is already some weeks old, but it is not too late to list my personal noteworthy items:

### Canary Builds

Integration builds that automatically use the latest versions of all dependencies.
Should be fairly easy to implement, and will probably give a good confidence for version upgrades (that tend to hit you in the most inappropriate moments). It could even be extended to programming languages (I am still using Java 7), build tools (strange things may happen to your dependency tree when upgrading Gradle), and open-source application servers (currently using a heavy-patched version of JBoss 7).

### Gitflow with long-living branches

[Gitflow](http://nvie.com/posts/a-successful-git-branching-model/) can be a nice door-opener when e.g. switching from Subversion to Git, but there is always the danger that you end up with multiple long-living branches and painful merges. Especially feature branches should be avoided.

### Programming in a CI/CD tool

Should be avoided (not new to me, but I will keep this for reference).
Always work towards a one-step build - this way, all the build logic is contained in your build script (and not hidden in some Jenkins config.xml file), so it is easy possible to execute the whole build from the command line. And of course the build scripts are versionized together with the source code - because they **are** part of the source code, remember?

### Tools

* **[Flyway](http://flywaydb.org/)** - How nice, my favourite database migration tool made it to the "adopt" stage...
* **[Gitlab](https://about.gitlab.com/)** - try it
* **[Blackbox](https://github.com/StackExchange/blackbox)** - try it
