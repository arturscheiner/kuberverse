#!/usr/bin/env bash
# kuberverse k8s lab provisioner
# type: kubeadm-calico-full-cluster-bootstrap
# created by Artur Scheiner - artur.scheiner@gmail.com

KVMSG=$1
MASTER_COUNT=$2
LB_ADDRESS=$3

echo "********** $KVMSG"
echo "********** $KVMSG"

# adding new files
# Extract and execute the kubeadm join command from the exported files
#$(cat /vagrant/kubeadm-init.out | grep -A 2 "kubeadm join" | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
#echo KUBELET_EXTRA_ARGS=--node-ip=10.8.8.$NODE_HOST_IP > /etc/default/kubelet

add-apt-repository ppa:vbernat/haproxy-2.0 -y
apt-get udpate
apt-get install -y haproxy

cat >> /etc/haproxy.cfg <<EOF
frontend kv-scaler
    bind $LB_ADDRESS:6443
    mode tcp
    log global
    option tcplog
    timeout client 3600s
    backlog 4096
    maxconn 50000
    use_backend kv-masters

backend kv-masters
    mode  tcp
    option log-health-checks
    option redispatch
    option tcplog
    balance roundrobin
    timeout connect 1s
    timeout queue 5s
    timeout server 3600s
EOF

i=0
while [ $i -le $MASTER_COUNT ]
do
cat >> haproxy.cfg <<EOF
        server kv-master-$i 10.8.8.1$i:6443 check
EOF
  ((i++))
done