---
layout:   post
title:    "Running a dockerized Jenkins pipeline on Windows"
category: dev
tags:     CI docker jenkins
comments: true
---

https://issues.jenkins-ci.org/browse/JENKINS-34454

1. Install Docker toolbox
1. Open the "Docker Quickstart Terminal"
1. Find out the current Docker settings:

```
Martin@latitude MINGW64 ~
$ env|grep DOCKER
DOCKER_HOST=tcp://192.168.99.100:2376
DOCKER_MACHINE_NAME=default
DOCKER_TLS_VERIFY=1
DOCKER_TOOLBOX_INSTALL_PATH=C:\Program Files\Docker Toolbox
DOCKER_CERT_PATH=C:\Users\Martin\.docker\machine\machines\default

Martin@latitude MINGW64 ~
$
```

1. Start Jenkins, providing these Docker environment vars:

```
set DOCKER_HOST=tcp://192.168.99.100:2376
set DOCKER_CERT_PATH=C:\Users\Martin\.docker\machine\machines\default
set DOCKER_MACHINE_NAME=default
set DOCKER_TLS_VERIFY=1
java -jar jenkins.war
```

1. Install the [Docker Pipeline Plugin](https://wiki.jenkins-ci.org/display/JENKINS/CloudBees+Docker+Pipeline+Plugin)
1. Save the new plugin version **TODO** to `~/.jenkins/plugins/docker-workflow.jpi` (overwriting the existing file)
1. Restart Jenkins
1. Create a "Pipeline" job with script:

```
stage("Demo")
docker.image("maven:3.3.3-jdk-8").inside {
  git(url: "https://github.com/martoe/continuous-delivery-thoughts.git")
  sh("mvn -B compile")
}
```

1. Run the job

```
[Pipeline] sh
[C:\Users\Martin\.jenkins\workspace\pipeline] Running shell script
sh: 1: cannot create C:\Users\Martin\.jenkins\workspace\pipeline@tmp\durable-d2fcf7bc\pid: Protocol error
sh: 1: cannot create C:\Users\Martin\.jenkins\workspace\pipeline@tmp\durable-d2fcf7bc\jenkins-log.txt: Protocol error
sh: 1: C:\Users\Martin\.jenkins\workspace\pipeline@tmp\durable-d2fcf7bc\script.sh: not found
sh: 1: cannot create C:\Users\Martin\.jenkins\workspace\pipeline@tmp\durable-d2fcf7bc\jenkins-result.txt: Protocol error
[Pipeline] } //withDockerContainer
```

--> hudson.FilePath uses the host system (Win) instead of the guest system (unix) to build the path
org.jenkinsci.plugins.durabletask.FileMonitoringTask


Other Jenkins home:
https://docs.docker.com/engine/userguide/containers/dockervolumes/#mount-a-host-directory-as-a-data-volume
