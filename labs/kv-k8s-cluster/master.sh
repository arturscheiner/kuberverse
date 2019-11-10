#!/usr/bin/env bash
# kuberverse k8s lab provisioner
# type: kubeadm-calico-full-cluster-bootstrap
# created by Artur Scheiner - artur.scheiner@gmail.com

KVMSG=$1
NODE=$2
POD_CIDR=$3
API_ADV_ADDRESS=$4

echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Initializing Kubernetes Cluster"
echo "********** $KVMSG ->> Master Node $NODE"
echo "********** $KVMSG ->> kv-master-$NODE"
kubeadm init --pod-network-cidr $POD_CIDR --apiserver-advertise-address $API_ADV_ADDRESS | tee /vagrant/kubeadm-init.out

echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Configuring Kubernetes Cluster Environment"
echo "********** $KVMSG"
echo "********** $KVMSG"
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config

#Configure the Calico Network Plugin
echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Configuring Kubernetes Cluster Calico Networking"
echo "********** $KVMSG ->> Downloading Calico YAML File"
echo "********** $KVMSG"
echo "********** $KVMSG"
wget -q https://docs.projectcalico.org/v3.10/manifests/calico.yaml -O /tmp/calico-default.yaml
#wget -q https://bit.ly/kv-lab-k8s-calico-yaml -O /tmp/calico-default.yaml
sed "s+192.168.0.0/16+$POD_CIDR+g" /tmp/calico-default.yaml > /tmp/calico-defined.yaml

echo "********** $KVMSG ->> Applying Calico YAML File"
echo "********** $KVMSG"
echo "********** $KVMSG"
kubectl apply -f /tmp/calico-defined.yaml
rm /tmp/calico-default.yaml /tmp/calico-defined.yaml
echo KUBELET_EXTRA_ARGS=--node-ip=10.8.8.1$NODE > /etc/default/kubelet