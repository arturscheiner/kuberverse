#!/usr/bin/env bash
# kuberverse kubernetes cluster lab
# version: 0.1.0-alpha
# description: this is the masters script file
# created by Artur Scheiner - artur.scheiner@gmail.com

KVMSG=$1
NODE=$2
POD_CIDR=$3
MASTER_IP=$4
MASTER_TYPE=$5

wget -q https://docs.projectcalico.org/v3.10/manifests/calico.yaml -O /tmp/calico-default.yaml
sed "s+192.168.0.0/16+$POD_CIDR+g" /tmp/calico-default.yaml > /tmp/calico-defined.yaml

if [ $MASTER_TYPE = "single" ]; then

    #echo "# Added by Kuberverse" > /vagrant/hosts.out
    #echo "$MASTER_IP     kv-master.lab.local     kv-master.local     kv-master" >> /vagrant/hosts.out

    kubeadm init --pod-network-cidr $POD_CIDR --apiserver-advertise-address $MASTER_IP --apiserver-cert-extra-sans kv-master.lab.local --apiserver-cert-extra-sans kv-scaler.lab.local | tee /vagrant/kubeadm-init.out

    k=$(grep -n "kubeadm join $MASTER_IP" /vagrant/kubeadm-init.out | cut -f1 -d:)
    x=$(echo $k | awk '{print $1}')
    awk -v ln=$x 'NR>=ln && NR<=ln+1' /vagrant/kubeadm-init.out | tee /vagrant/workers-join.out

else

    if (( $NODE == 0 )) ; then

        ip route del default
        ip route add default via $MASTER_IP
        kubeadm init --control-plane-endpoint "kv-scaler.lab.local:6443" --upload-certs --pod-network-cidr $POD_CIDR --apiserver-cert-extra-sans kv-master.lab.local | tee /vagrant/kubeadm-init.out

        k=$(grep -n "kubeadm join kv-scaler.lab.local" /vagrant/kubeadm-init.out | cut -f1 -d:)
        x=$(echo $k | awk '{print $1}')
        awk -v ln=$x 'NR>=ln && NR<=ln+2' /vagrant/kubeadm-init.out | tee /vagrant/masters-join.out
        awk -v ln=$x 'NR>=ln && NR<=ln+1' /vagrant/kubeadm-init.out | tee /vagrant/workers-join.out

    else
        ip route del default
        ip route add default via $MASTER_IP
        $(cat /vagrant/masters-join.out | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
    fi

fi

mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config

mkdir -p /vagrant/.kube
cp -i /etc/kubernetes/admin.conf /vagrant/.kube/config

if (( $NODE == 0 )) ; then
    kubectl apply -f /tmp/calico-defined.yaml
fi

echo KUBELET_EXTRA_ARGS=--node-ip=$MASTER_IP  > /etc/default/kubelet
systemctl restart networking
systemctl restart kubelet
