#!/usr/bin/env bash

echo ********** Adding Kubernetes Repo
echo "deb  http://apt.kubernetes.io/  kubernetes-xenial  main" > /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo ********** Updating Repo
apt-get update
echo ********** Upgrading Packages
apt-get upgrade -y
echo ********** Installing Required & Recommended Packages
apt-get install -y avahi-daemon libnss-mdns traceroute htop httpie bash-completion docker.io kubeadm kubelet kubectl