FROM ubuntu:14.04

MAINTAINER KiwenLau <kiwenlau@gmail.com>

# Setup mesosphere repository
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]') && \
CODENAME=$(lsb_release -cs) && \
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list && \
sudo apt-get -y update

# Install mesos and marathon (The Mesos package will automatically pull in the ZooKeeper package as a dependency)
RUN sudo apt-get -y install vim mesos marathon

EXPOSE 8080 5050

# init script
ADD start-cluster.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-cluster.sh
CMD '/usr/local/bin/start-cluster.sh'; bash

