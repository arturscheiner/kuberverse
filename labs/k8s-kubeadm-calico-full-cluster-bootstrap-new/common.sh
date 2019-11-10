#!/usr/bin/env bash

#variable definitions
KVMSG=$1

echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Adding Kubernetes Repo"
echo "********** $KVMSG"
echo "********** $KVMSG"
echo "deb  http://apt.kubernetes.io/  kubernetes-xenial  main" > /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Updating Repo"
echo "********** $KVMSG"
echo "********** $KVMSG"
apt-get update

#echo "********** $KVMSG"
#echo "********** $KVMSG"
#echo "********** $KVMSG ->> Upgrading Packages"
#echo "********** $KVMSG"
#echo "********** $KVMSG"
#apt-get upgrade -y

echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Installing Required & Recommended Packages"
echo "********** $KVMSG"
echo "********** $KVMSG"
apt-get install -y avahi-daemon libnss-mdns traceroute htop httpie bash-completion docker.io kubeadm kubelet kubectl