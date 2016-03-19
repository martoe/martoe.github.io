---
layout:   post
title:    "My first Docker steps"
category: dev
tags:     CI docker jenkins
comments: true
---

The [Jenkins 2.0 alpha version](https://jenkins-ci.org/blog/2016/02/29/jenkins2-alphas/) is a good opportunity for me to finally spend some time with Docker (some two years late, shame on me).
So, this is a short documentation of my steps to a dockerized Jenkins 2.0 instance on my Windows 10 box:

##  Lesson #1: Run Jenkins in a Docker container (without prior Docker knowledge)

1. Install Docker as described at https://docs.docker.com/windows/ (I'm using Docker Toolbox v1.10.3). This also installs [VirtualBox](https://www.virtualbox.org/) and creates a virtual Linux machine (Docker uses a Linux virtualization feature that is not available on Windows)
1. Launch the "Docker Quickstart Terminal"
1. Locate the Jenkins 2.0 image at the [Docker hub](https://hub.docker.com/r/jenkinsci/jenkins/tags/) (The [official Jenkins repo](https://hub.docker.com/_/jenkins/) contains no alpha versions)
1. Create and start a new Jenkins container with `docker run -p 8080:8080 -p 50000:50000 jenkinsci/jenkins:2.0-alpha-3`. After the image download, Jenkins initializes and starts within 20 seconds. Wait until the security token appears at the console.
1. Open http://192.168.99.100:8080/ in a browser (find out the real IP address with `docker-machine ip`) and enter the security token. Welcome to Jenkins 2.0 :-)
1. Now remove the container again

    ```
    docker ps
    docker inspect <id>
    docker stop <id>
    docker rm <id>
    ```

## Lesson #2: Write the Jenkins workspace to a local (Windows) directory

    cd ~
    mkdir docker
    mkdir docker/jenkins
    docker run --name jenkins2 -p 8080:8080 -p 50000:50000 -v ~/docker/jenkins:/var/jenkins_home jenkinsci/jenkins:2.0-alpha-3

The first startup takes about 7 minutes(!), the following startup is much faster (which means that writing to the host filesystem is pretty slow on Windows) 

Notes:

* Out of the box, only `c:\Users` is available for mounting
* Even local (Windows) filenames are case sensitive.
* see https://docs.docker.com/engine/userguide/containers/dockervolumes/
* using the `--name` option, it is easier to reference the container later:

```
docker start jenkins2
docker exec -i -t jenkins2 bash
docker stop jenkins2
docker rm jenkins2
```        

## Lesson #3: Write the Jenkins workspace to a data volume (for better performance)

    docker run --name jenkins2 -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home jenkinsci/jenkins:2.0-alpha-3
    docker volume ls
    docker volume inspect jenkins-data

AFAIK it is not possible to directly access the files inside the data container.
But we can always launch another container, mount both the data volume and a local directory, and copy the files:

    docker run -v jenkins-data:/var/jenkins_home -v ~/docker:/backup debian tar czf /backup/jenkins-backup.tgz /var/jenkins_home/*



