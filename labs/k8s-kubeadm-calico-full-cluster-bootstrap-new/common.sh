#!/usr/bin/env bash
VAR=$1
echo ********** $VAR
echo ********** $VAR
echo ********** Adding Kubernetes Repo
echo **********
echo **********
echo "deb  http://apt.kubernetes.io/  kubernetes-xenial  main" > /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

echo **********
echo **********
echo ********** Updating Repo
echo **********
echo **********
apt-get update

echo **********
echo **********
echo ********** Upgrading Packages
echo **********
echo **********
apt-get upgrade -y

echo **********
echo **********
echo ********** Installing Required & Recommended Packages
echo **********
echo **********
apt-get install -y avahi-daemon libnss-mdns traceroute htop httpie bash-completion docker.io kubeadm kubelet kubectl