#!/usr/bin/env bash
# kuberverse kubernetes cluster lab
# version: 0.2.0
# description: this is the masters script file
# created by Artur Scheiner - artur.scheiner@gmail.com

KVMSG=$1
NODE=$2
POD_CIDR=$3
MASTER_IP=$4
CNI_PROVIDER=$5
MASTER_TYPE=$6

if [ $MASTER_TYPE = "single" ]; then

    sed -i "s+# PassThroughPattern: \.\*+PassThroughPattern: .*+g" /etc/apt-cacher-ng/acng.conf
    systemctl start apt-cacher-ng
    systemctl enable apt-cacher-ng
    #echo "# Added by Kuberverse" > /vagrant/hosts.out
    #echo "$MASTER_IP     kv-master.lab.local     kv-master.local     kv-master" >> /vagrant/hosts.out

    kubeadm init --pod-network-cidr $POD_CIDR --apiserver-advertise-address $MASTER_IP --apiserver-cert-extra-sans kv-master.lab.local --apiserver-cert-extra-sans kv-scaler.lab.local | tee /vagrant/kubeadm-init.out

    k=$(grep -n "kubeadm join $MASTER_IP" /vagrant/kubeadm-init.out | cut -f1 -d:)
    x=$(echo $k | awk '{print $1}')
    awk -v ln=$x 'NR>=ln && NR<=ln+1' /vagrant/kubeadm-init.out | tee /vagrant/workers-join.out

else

    if (( $NODE == 0 )) ; then

        sed -i "s+# PassThroughPattern: \.\*+PassThroughPattern: .*+g" /etc/apt-cacher-ng/acng.conf
        systemctl start apt-cacher-ng
        systemctl enable apt-cacher-ng

        kubeadm init --control-plane-endpoint "kv-scaler.lab.local:6443" --apiserver-advertise-address $MASTER_IP --upload-certs --pod-network-cidr $POD_CIDR --apiserver-cert-extra-sans kv-master.lab.local --apiserver-cert-extra-sans kv-scaler.lab.local | tee /vagrant/kubeadm-init.out

        k=$(grep -n "kubeadm join kv-scaler.lab.local" /vagrant/kubeadm-init.out | cut -f1 -d:)
        x=$(echo $k | awk '{print $1}')
        awk -v ln=$x 'NR>=ln && NR<=ln+2' /vagrant/kubeadm-init.out | tee /vagrant/masters-join-default.out      
        awk -v ln=$x 'NR>=ln && NR<=ln+1' /vagrant/kubeadm-init.out | tee /vagrant/workers-join.out
    else
        sed "s+kubeadm join kv-scaler.lab.local:6443+kubeadm join kv-scaler.lab.local:6443 --apiserver-advertise-address $MASTER_IP+g" /vagrant/masters-join-default.out > /vagrant/masters-join-$NODE.out
        $(cat /vagrant/masters-join-$NODE.out | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
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
    case $CNI_PROVIDER in
    calico)
        wget -q https://docs.projectcalico.org/manifests/calico.yaml -O /tmp/calico-default.yaml
        sed "s+192.168.0.0/16+$POD_CIDR+g" /tmp/calico-default.yaml > /tmp/calico-defined.yaml
        kubectl apply -f /tmp/calico-defined.yaml
        ;;
    weave)
        wget -q "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=$POD_CIDR" -O /tmp/weave-defined.yaml
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
  sed -i "s+KUBELET_EXTRA_ARGS=\"+KUBELET_EXTRA_ARGS=\"--node-ip=$MASTER_IP +g" /etc/default/kubelet
else
  echo KUBELET_EXTRA_ARGS=--node-ip=$MASTER_IP  >> /etc/default/kubelet
fi

systemctl restart networking
systemctl restart kubelet
