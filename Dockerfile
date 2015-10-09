FROM ubuntu:14.04

MAINTAINER KiwenLau <kiwenlau@gmail.com>

# Setup mesosphere repository
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]') && \
CODENAME=$(lsb_release -cs) && \
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list && \
sudo apt-get -y update

# Install vim and curl for programming and test
RUN sudo apt-get -y install vim curl

# Install docker 
RUN curl -fLsS https://get.docker.com/ | sh

# Install Java 8 from Oracle's PPA
RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository ppa:webupd8team/java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN sudo apt-get update -y
RUN sudo apt-get install -y oracle-java8-installer oracle-java8-set-default

# Install mesos and marathon (The Mesos package will automatically pull in the ZooKeeper package as a dependency)
RUN sudo apt-get -y install mesos marathon

# Update Mesos slave configuration to specify the use of the Docker containerizer
RUN echo 'docker,mesos' > /etc/mesos-slave/containerizers
RUN echo '5mins' > /etc/mesos-slave/executor_registration_timeout

USER root

WORKDIR /root

EXPOSE 8080 5050

ADD hello1.json /root/hello1.json
ADD hello2.json /root/hello2.json

# Add script for start the mesos/marathon cluster
ADD start-cluster.sh /root/start-cluster.sh
RUN chmod +x /root/start-cluster.sh
CMD '/root/start-cluster.sh'; bash

