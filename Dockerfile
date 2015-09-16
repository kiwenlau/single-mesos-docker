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

# Install mesos and marathon (The Mesos package will automatically pull in the ZooKeeper package as a dependency)
RUN sudo apt-get -y install mesos marathon

USER root

WORKDIR /root

EXPOSE 8080 5050

ADD hello.json /root/hello.json

# Add script for start the mesos/marathon cluster
ADD start-cluster.sh /root/start-cluster.sh
RUN chmod +x /root/start-cluster.sh
CMD '/root/start-cluster.sh'; bash

