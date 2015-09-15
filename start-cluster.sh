#!/bin/bash

# Start ZooKeeper
sudo service zookeeper restart

# Start Mesos and Marathon
sudo service mesos-master restart
sudo service mesos-slave restart
sudo service marathon restart
