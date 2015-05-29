#!/bin/bash

# workaround logging issues
# note this cant go in Vagrantfile as it breaks provisioning
# default: dpkg-reconfigure: unable to re-open stdin: No file or directory
# http://serverfault.com/a/670688
export DEBIAN_FRONTEND=noninteractive

echo "Updating Apt"
apt-get update > /dev/null 2>&1


echo "Installing Provisioning Dependencies"
apt-get install -y build-essential wget > /dev/null 2>&1


wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add - > /dev/null 2>&1
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list' > /dev/null 2>&1
sudo apt-get update > /dev/null 2>&1
sudo apt-get  install -y jenkins > /dev/null 2>&1

