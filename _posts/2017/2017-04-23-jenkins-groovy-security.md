---
layout:   post
title:    "Dodging Security Issues of the Jenkins Groovy Plugin"
category: dev
tags:     CI groovy jenkins
comments: true
---

The recent [Jenkins security advisory](https://jenkins.io/security/advisory/2017-04-10/) discloses a (quite obvious, in retrospect) security issue regarding the "Execute system Groovy script" build step ([SECURITY-292](https://jenkins.io/security/advisory/2017-04-10/#groovy-plugin)).
The recommended solution is to update the [Groovy plugin](https://plugins.jenkins.io/groovy) to version 2.0+, which integrates the [script security plugin](https://wiki.jenkins-ci.org/display/JENKINS/Script+Security+Plugin). Sounds easy, but can be very hard (almost impossible) in practice...

## Approval for Inline Scripts

After updating the Groovy plugin to version 2.0 and restarting Jenkins, every job that contains a system script must be approved by an administrator. Running a job with an "inline" system script without prior approval would fail:

    ERROR: Build step failed with exception
    org.jenkinsci.plugins.scriptsecurity.scripts.UnapprovedUsageException: script not yet approved for use
      at org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval.using(ScriptApproval.java:459)
      at org.jenkinsci.plugins.scriptsecurity.sandbox.groovy.SecureGroovyScript.evaluate(SecureGroovyScript.java:170)
      at hudson.plugins.groovy.SystemGroovy.run(SystemGroovy.java:95)
      at hudson.plugins.groovy.SystemGroovy.perform(SystemGroovy.java:59)
      [...]
    Build step 'Execute system Groovy script' marked build as failure

When navigating to "Manage Jenkins" -> "In-process Script Approval", a list of all system Groovy scripts is displayed.
As soon as an administrator approves these scripts, the jobs are running again. (Unfortunately, the "script approval" page only shows the content of the scripts without reference to the owning job, which makes it hard to maintain large Jenkins instances.)

An alternative way to approve a system script is to open the configuration of the corresponding job and save it without modifications (if the "save" operation is performed by an administrator, all system scripts will be approved automatically).
 
## Approval for Script Files

I prefer using script files instead of inline scripts because they are easier to maintain (I usually commit them to the SCM).
This is the point when things start getting ugly.  

Of course, Jenkins cannot approve such a script file a priori, because the content may change over time (a user with low privileges may commit a malicious change to the script file, and Jenkins would happily execute it during the next build).
Instead, Jenkins asks for permission of each and every statement within the script file.

    ERROR: Build step failed with exception
    org.jenkinsci.plugins.scriptsecurity.sandbox.RejectedAccessException: Scripts not permitted to use new java.io.File java.lang.String
      at org.jenkinsci.plugins.scriptsecurity.sandbox.whitelists.StaticWhitelist.rejectNew(StaticWhitelist.java:187)
      at org.jenkinsci.plugins.scriptsecurity.sandbox.groovy.SandboxInterceptor.onNewInstance(SandboxInterceptor.java:130)
      at org.kohsuke.groovy.sandbox.impl.Checker$3.call(Checker.java:191)
      [...]
    Build step 'Execute system Groovy script' marked build as failure

In this situation, you will probably find yourself in an almost infinite loop:

1. execute the job
2. check the job console for errors
3. approve the command at the "script approval" page
4. start over

For example, look at this very simple script:

{% highlight groovy %}
def file = new File("tmp.txt") // 1
file.setText("Hello world") // 2
println "Reading from file $file.absolutePath: $file.text" // 3
{% endhighlight %}

For this three-line script, no less than **five** approvals are required:

    new java.io.File java.lang.String
    staticMethod org.codehaus.groovy.runtime.DefaultGroovyMethods setText java.io.File java.lang.String
    method groovy.lang.Script println java.lang.Object
    method java.io.File getAbsolutePath
    staticMethod org.codehaus.groovy.runtime.DefaultGroovyMethods getText java.io.File

This is very cumbersome, and there are many cases where an approval isn't possible at all (due to the Groovy syntax).
For example, when changing the second line of the above script to `file.text = "Hello world"`, the script would fail with an error:

    ERROR: Build step failed with exception
    org.jenkinsci.plugins.scriptsecurity.sandbox.RejectedAccessException: unclassified field java.io.File text
      at org.jenkinsci.plugins.scriptsecurity.sandbox.groovy.SandboxInterceptor.unclassifiedField(SandboxInterceptor.java:367)
      at org.jenkinsci.plugins.scriptsecurity.sandbox.groovy.SandboxInterceptor.onSetProperty(SandboxInterceptor.java:217)
      at org.kohsuke.groovy.sandbox.impl.Checker$5.call(Checker.java:297)
      [...]
    Build step 'Execute system Groovy script' marked build as failure

[JENKINS-27306](https://issues.jenkins-ci.org/browse/JENKINS-27306) lists such errors, no fix or workaround yet.

## System Script Files: Say Goodbye to Security

But here comes the really nasty part: once that such methods have been approved, they are globally granted.
This means that (given the example above) from now on any job may read and write arbitrary files because of the `getText` and `setText` approvals.

The script security plugin is aware of this, as the `new java.io.File java.lang.String` method is accompanied with the message:

> Signatures already approved which **may have introduced a security vulnerability** (recommend clearing)

## Recommendations

At this point, you probably have to choose one of three options:

1. **Don't use System Groovy scripts at all.** This is of course the most secure option, but it probably requires a complete redesign of such jobs. Furthermore, it is no longer possible to perform Jenkins maintenance tasks with Jenkins jobs. 
2. **Inline all System Groovy scripts.** This may be fine with maintenance tasks (like automatically creating new jobs for new SCM branches), but is a bad idea for scripts that are part of the build process (which should be versionized together with the source code).
3. **Turn off script security.** Only do this if you are running a private Jenkins instance with 100% trusted users.
    * install the [Permissive Script Security Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Permissive+Script+Security+Plugin)
    * start Jenkins with VM argument `-Dpermissive-script-security.enabled=true` - now all unsecured scripts are executed without approval.
    * note that this won't work for scripts with unsupported syntax (see the [JENKINS-27306](https://issues.jenkins-ci.org/browse/JENKINS-27306) issue mentioned above)
