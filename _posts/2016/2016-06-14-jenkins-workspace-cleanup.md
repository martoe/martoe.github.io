---
layout:   post
title:    "Cleaning up Jenkins Workspaces"
category: dev
tags:     CI jenkins
comments: true
---

When running a Jenkins server with many jobs and many agents, you can quickly run out of disk space because of orphan workspaces:

* Jobs may roam on different agents, leaving a workspace on each
* Each concurrent job execution needs its own workspace
* When renaming or deleting a job, the workspaces may still survive on the disk (with the original job name)

With the [Workspace Cleanup Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Workspace+Cleanup+Plugin), the workspace may be deleted after a job execution (as post-build action), but this has other drawbacks:

* Every job execution needs a full SCM checkout (instead of an update), which can be very time-consuming
* If something goes wrong, there is no workspace for a post-mortem analysis

My solution is a simple Groovy script that iterates through all workspace directories on all agents, and deletes a workspace if it is older than one day:

```
def deleted = []
def oneDayAgo = new Date() - 1
jenkins.model.Jenkins.instance.nodes.each { hudson.model.Node node ->
  node.workspaceRoot.listDirectories().each { hudson.FilePath path ->
    def pathName = path.getRemote()
    if (path.name.startsWith(".")) {
      println "Skipping internal dir $node.displayName:$pathName"
    } else {
	    def lastModified = new Date(path.lastModified())
      if (lastModified < oneDayAgo) {
        println "Deleting workspace at $node.displayName:$pathName (last modified $lastModified)"
        path.deleteRecursive()
        deleted << "$node.displayName:$pathName"
      } else {
        println "Skipping workspace at $node.displayName:$pathName (last modified $lastModified)"
      }
    }
  }
}
"Deleted workspaces: \n\t" + deleted.sort().join("\n\t")
```

Of course this assumes that all jobs use the default workspace location.

This can either be executed with the [Jenkins Script Console](https://wiki.jenkins-ci.org/display/JENKINS/Jenkins+Script+Console) or as part of a scheduled maintenance job, using a [System Groovy Script](https://wiki.jenkins-ci.org/display/JENKINS/Groovy+plugin).
