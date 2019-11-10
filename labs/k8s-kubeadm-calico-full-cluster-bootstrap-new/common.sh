#!/usr/bin/env bash

#variable definitions
KVMSG=$1


# Install Docker CE
## Set up the repository:
### Install packages to allow apt to use a repository over HTTPS
apt-get update && apt-get install apt-transport-https ca-certificates curl software-properties-common

### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

### Add Docker apt repository.
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

## Install Docker CE.
apt-get update && apt-get install docker-ce

# Setup daemon.
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

#mkdir -p /etc/systemd/system/docker.service.d

systemctl enable docker.service

# Restart docker.
systemctl daemon-reload
systemctl restart docker

echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Adding Kubernetes Repo"
echo "********** $KVMSG"
echo "********** $KVMSG"
apt-get update && apt-get install apt-transport-https ca-certificates curl software-properties-common
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
apt-get install -y avahi-daemon libnss-mdns traceroute htop httpie bash-completion kubeadm kubelet kubectl
