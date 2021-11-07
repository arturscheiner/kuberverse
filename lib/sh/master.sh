#!/usr/bin/env bash
# kuberverse kubernetes cluster lab
# version: 0.5.0
# description: this is the masters script file
# created by Artur Scheiner - artur.scheiner@gmail.com

if [ $KV_MASTER_TYPE = "single" ]; then

    kubeadm init --pod-network-cidr $KV_POD_CIDR \
                 --apiserver-advertise-address $KV_THIS_IP \
                 --apiserver-cert-extra-sans kv-master-0.lab.local | tee /vagrant/.kv/kubeadm-init.log

    k=$(grep -n "kubeadm join $KV_THIS_IP" /vagrant/.kv/kubeadm-init.log | cut -f1 -d:)
    x=$(echo $k | awk '{print $1}')
    awk -v ln=$x 'NR>=ln && NR<=ln+1' /vagrant/.kv/kubeadm-init.log | tee /vagrant/.kv/workers-join

else

    if [ $KV_THIS_NODE = "0" ] ; then

        kubeadm init --control-plane-endpoint "kv-scaler-0.lab.local:6443" \
                     --apiserver-advertise-address $KV_THIS_IP \
                     --upload-certs --pod-network-cidr $KV_POD_CIDR \
                     --apiserver-cert-extra-sans kv-scaler-0.lab.local | tee /vagrant/.kv/kubeadm-init.log

        k=$(grep -n "kubeadm join kv-scaler-0.lab.local" /vagrant/.kv/kubeadm-init.log | cut -f1 -d:)
        x=$(echo $k | awk '{print $1}')
        awk -v ln=$x 'NR>=ln && NR<=ln+2' /vagrant/.kv/kubeadm-init.log | tee /vagrant/.kv/masters-join-default  
        awk -v ln=$x 'NR>=ln && NR<=ln+1' /vagrant/.kv/kubeadm-init.log | tee /vagrant/.kv/workers-join
    else
        sed "s+lab.local:6443+lab.local:6443 --apiserver-advertise-address $KV_THIS_IP+g" /vagrant/.kv/masters-join-default > /vagrant/.kv/masters-join-$KV_THIS_NODE
        $(cat /vagrant/.kv/masters-join-$KV_THIS_NODE | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
    fi
fi

mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config

mkdir -p /vagrant/.kv
cp -i /etc/kubernetes/admin.conf /vagrant/.kv/kube-config

if (( $KV_THIS_NODE == 0 )) ; then
    case $KV_CNI_PROVIDER in
    calico)
        wget -q https://docs.projectcalico.org/manifests/calico.yaml -O /tmp/calico-default.yaml
        sed "s+192.168.0.0/16+$KV_POD_CIDR+g" /tmp/calico-default.yaml > /tmp/calico-defined.yaml
        kubectl apply -f /tmp/calico-defined.yaml
        ;;
    weave)
        wget -q "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=$KV_POD_CIDR" -O /tmp/weave-defined.yaml
        kubectl apply -f /tmp/weave-defined.yaml
        ;;

    flannel)
        #not supported yet
        ;;
    *)
        #no default defined
        ;;
    esac   
fi

if grep -E "KUBELET_EXTRA_ARGS=" /etc/default/kubelet ; then
  sed -i "s+KUBELET_EXTRA_ARGS=\"+KUBELET_EXTRA_ARGS=\"--node-ip=$KV_THIS_IP +g" /etc/default/kubelet
else
  echo KUBELET_EXTRA_ARGS=--node-ip=$KV_THIS_IP  >> /etc/default/kubelet
fi

systemctl restart networking
systemctl restart kubelet
