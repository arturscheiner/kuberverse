#!/usr/bin/env bash
# kuberverse kubernetes cluster lab
# version: 0.5.0
# description: this is the workers script file
# created by Artur Scheiner - artur.scheiner@gmail.com

#if [ $KV_MASTER_TYPE = "single" ]; then
#    $(cat /vagrant/kubeadm-init.out | grep -A 2 "kubeadm join" | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
#else
    $(cat /vagrant/.kv/workers-join | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
#fi

if grep -E "KUBELET_EXTRA_ARGS=" /etc/default/kubelet ; then
  sed -i "s+KUBELET_EXTRA_ARGS=\"+KUBELET_EXTRA_ARGS=\"--node-ip=$KV_THIS_IP +g" /etc/default/kubelet
else
  echo KUBELET_EXTRA_ARGS=--node-ip=$KV_THIS_IP  >> /etc/default/kubelet
fi

mkdir -p /home/vagrant/.kube /root/.kube
cp -i /vagrant/.kv/kube-config /home/vagrant/.kube/config
cp -i /vagrant/.kv/kube-config /root/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

systemctl restart kubelet
