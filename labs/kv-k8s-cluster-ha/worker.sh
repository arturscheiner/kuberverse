#!/usr/bin/env bash
# kuberverse kubernetes cluster lab
# version: 0.1.0-alpha
# description: this is the workers script file
# type: kubeadm-calico-full-cluster-bootstrap
# created by Artur Scheiner - artur.scheiner@gmail.com

KVMSG=$1
NODE=$2
WORKER_IP=$3
MASTER_TYPE=$4

if [ $MASTER_TYPE = "single" ]; then
    $(cat /vagrant/kubeadm-init.out | grep -A 2 "kubeadm join" | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
else
    $(cat /vagrant/workers-join.out | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
fi

echo KUBELET_EXTRA_ARGS=--node-ip=$WORKER_IP > /etc/default/kubelet

systemctl restart kubelet
