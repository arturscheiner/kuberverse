#!/usr/bin/env bash
# kuberverse kubernetes cluster lab
# version: 0.1.0-alpha-a
# description: this is a common script file for masters and workers
# created by Artur Scheiner - artur.scheiner@gmail.com

#variable definitions
KVMSG=$1
BOX_IMAGE=$2
KUBE_VERSION=$3
CONTAINER_RUNTIME=$4
#NODE_ADDRESS=$2
#MASTER_TYPE=$3


if [[ ! $BOX_IMAGE =~ "kuberverse" ]]
then

  UBUNTU_CODENAME=$(lsb_release -cs)

  export DEBIAN_FRONTEND=noninteractive

  ### Install packages to allow apt to use a repository over HTTPS
  apt update
  apt install -y apt-transport-https ca-certificates curl software-properties-common

  ### Add Kubernetes GPG key
  #curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
  
  ### Kubernetes Repo
  #add-apt-repository "deb http://apt.kubernetes.io/ kubernetes-$UBUNTU_CODENAME main"
  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

  ### Add Docker’s official GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

  ### Add Docker apt repository
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable"

  ### Refresh apt cache install packages
  apt update

  apt install -y nfs-kernel-server nfs-common \
                    traceroute htop httpie bash-completion ruby \
                    kubelet=${KUBE_VERSION}-00 kubeadm=${KUBE_VERSION}-00 kubectl=${KUBE_VERSION}-00 kubernetes-cni
fi

cat /vagrant/hosts.out >> /etc/hosts

case $CONTAINER_RUNTIME in
containerd)
apt install -y containerd
### containerd

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system
sudo mkdir -p /etc/containerd


### containerd config
cat > /etc/containerd/config.toml <<EOF
disabled_plugins = []
imports = []
oom_score = 0
plugin_dir = ""
required_plugins = []
root = "/var/lib/containerd"
state = "/run/containerd"
version = 2

[plugins]

  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
      base_runtime_spec = ""
      container_annotations = []
      pod_annotations = []
      privileged_without_host_devices = false
      runtime_engine = ""
      runtime_root = ""
      runtime_type = "io.containerd.runc.v2"

      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
        BinaryName = ""
        CriuImagePath = ""
        CriuPath = ""
        CriuWorkPath = ""
        IoGid = 0
        IoUid = 0
        NoNewKeyring = false
        NoPivotRoot = false
        Root = ""
        ShimCgroup = ""
        SystemdCgroup = true
EOF


### crictl uses containerd as default
{
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
EOF
}


### kubelet should use containerd
{
cat <<EOF | sudo tee /etc/default/kubelet
KUBELET_EXTRA_ARGS="--container-runtime remote --container-runtime-endpoint unix:///run/containerd/containerd.sock"
EOF
}


### install podman
apt install software-properties-common -y
add-apt-repository -y ppa:projectatomic/ppa
sudo apt -qq -y install podman containers-common
cat <<EOF | sudo tee /etc/containers/registries.conf
[registries.search]
registries = ['docker.io']
EOF


### start services
systemctl daemon-reload
systemctl enable containerd
systemctl restart containerd
systemctl enable kubelet && systemctl start kubelet
;;
docker)
apt install -y docker-ce=5:18.09.1~3-0~ubuntu-$UBUNTU_CODENAME
# Setup Docker daemon
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

# Restart docker
systemctl daemon-reload
systemctl restart docker

;;
cri-o)
#not supported yet
;;
*)
#no default defined
;;
esac

if [[ ! $BOX_IMAGE =~ "kuberverse" ]]
then
  kubeadm config images pull
fi
