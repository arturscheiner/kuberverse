#!/usr/bin/env bash
# kuberverse k8s lab provisioner
# type: kubeadm-calico-full-cluster-bootstrap
# created by Artur Scheiner - artur.scheiner@gmail.com

KVMSG=$1
NODE=$2
POD_CIDR=$3
SCALER_ADDRESS=$4
MASTER_IP=$4
MASTER_TYPE=$5

echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Initializing Kubernetes Cluster"
echo "********** $KVMSG ->> Master Node $NODE"
echo "********** $KVMSG ->> kv-master-$NODE"

kubeadm config images pull

cat /vagrant/hosts.out >> /etc/hosts

if (( $NODE == 0 )) ; then

    #Configure the Calico Network Plugin
    echo "********** $KVMSG"
    echo "********** $KVMSG"
    echo "********** $KVMSG"
    echo "********** $KVMSG ->> Downloading Calico YAML File"
    echo "********** $KVMSG"
    echo "********** $KVMSG"
    wget -q https://docs.projectcalico.org/v3.10/manifests/calico.yaml -O /tmp/calico-default.yaml
    sed "s+192.168.0.0/16+$POD_CIDR+g" /tmp/calico-default.yaml > /tmp/calico-defined.yaml

    ip route del default
    ip route add default via 10.8.8.1$NODE
    kubeadm init --control-plane-endpoint "kv-scaler-0.local:6443" --upload-certs --pod-network-cidr $POD_CIDR --apiserver-advertise-address 10.8.8.1$NODE | tee /vagrant/kubeadm-init.out

    k=$(grep -n "kubeadm join scaler" /vagrant/kubeadm-init.out | cut -f1 -d:)
    x=$(echo $x | awk '{print $1}')
    awk -v ln=$x 'NR>=ln && NR<=ln+2' /vagrant/kubeadm-init.out | tee /vagrant/masters-join.out
    awk -v ln=$x 'NR>=ln && NR<=ln+1' /vagrant/kubeadm-init.out | tee /vagrant/workers-join.out

    echo "********** $KVMSG"
    echo "********** $KVMSG"
    echo "********** $KVMSG"
    echo "********** $KVMSG ->> Applying Calico YAML File"
    echo "********** $KVMSG"
    echo "********** $KVMSG"
    kubectl apply -f /tmp/calico-defined.yaml
    rm /tmp/calico-default.yaml /tmp/calico-defined.yaml
else
    #$(cat masters-join.out | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
    kubeadm reset -f
    ip route del default
    $(cat masters-join.out | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
fi

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


echo KUBELET_EXTRA_ARGS=--node-ip=10.8.8.1$NODE > /etc/default/kubelet
systemctl restart networking