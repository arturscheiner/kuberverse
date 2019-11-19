#!/usr/bin/env bash
# kuberverse k8s lab provisioner
# type: kubeadm-calico-full-cluster-bootstrap
# created by Artur Scheiner - artur.scheiner@gmail.com

KVMSG=$1
NODE=$2
NODE_HOST_IP=20+$NODE
POD_CIDR=$3
API_ADV_ADDRESS=$4

echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Joining Kubernetes Cluster"
echo "********** $KVMSG ->> Worker Node $NODE"
echo "********** $KVMSG ->> kv-worker-$NODE"

# Extract and execute the kubeadm join command from the exported file
#$(cat /vagrant/kubeadm-init.out | grep -A 2 "kubeadm join" | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
$(cat workers-join.out | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
echo KUBELET_EXTRA_ARGS=--node-ip=10.8.8.$NODE_HOST_IP > /etc/default/kubelet