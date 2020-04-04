#!/usr/bin/env bash
# kuberverse kubernetes cluster lab
# version: 0.1.0-alpha-a
# description: this is a common script file for masters and workers
# created by Artur Scheiner - artur.scheiner@gmail.com

#variable definitions
KVMSG=$1
NODE_ADDRESS=$2
MASTER_TYPE=$3

### Install packages to allow apt to use a repository over HTTPS
apt-get update && apt-get install apt-transport-https ca-certificates curl software-properties-common

### Add Kubernetes GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

### Kubernetes Repo
echo "deb  http://apt.kubernetes.io/  kubernetes-xenial  main" > /etc/apt/sources.list.d/kubernetes.list

### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

### Add Docker apt repository.
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"


apt-get update

apt-get install -y nfs-kernel-server nfs-common avahi-daemon libnss-mdns traceroute htop httpie bash-completion ruby docker-ce=5:18.09.1~3-0~ubuntu-xenial kubeadm kubelet kubectl

#modprobe nf_conntrack

cat /vagrant/hosts.out >> /etc/hosts

# Setup Docker daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker

kubeadm config images pull