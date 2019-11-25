#!/usr/bin/env bash
# kuberverse k8s lab provisioner scaler
# type: kubeadm-calico-full-cluster-bootstrap
# created by Artur Scheiner - artur.scheiner@gmail.com

KVMSG=$1
SCALER_IP=$2
MASTER_IPS=$(echo $3 | sed -e 's/,//g' -e 's/\]//g' -e 's/\[//g')

echo "********** $KVMSG"
echo "********** $KVMSG"

echo "********** $SCALER_IP"
echo "********** $MASTER_IPS"

### Install packages to allow apt to use a repository over HTTPS
apt-get update && apt-get install apt-transport-https ca-certificates curl software-properties-common haproxy

### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

### Add Docker apt repository.
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

add-apt-repository ppa:vbernat/haproxy-2.0 -y

echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Updating Repositories"
echo "********** $KVMSG"
echo "********** $KVMSG"
apt-get update

echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Installing Required & Recommended Packages"
echo "********** $KVMSG"
echo "********** $KVMSG"
apt-get install -y avahi-daemon libnss-mdns traceroute htop httpie bash-completion haproxy ruby docker-ce


#apt-get install haproxy -y

cat >> /etc/haproxy/haproxy.cfg <<EOF
frontend kv-scaler
    bind $SCALER_IP:6443
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
for mips in $MASTER_IPS; do
  echo "  server kv-master-$i $mips:6443 check" >> /etc/haproxy/haproxy.cfg
  ((i++))
done

cat > /vagrant/hosts.out<<EOF
# Added by $KVMSG
$SCALER_IP     kv-scaler.lab.local     kv-scaler.local     kv-scaler
EOF

cat /vagrant/hosts.out >> /etc/hosts

systemctl restart haproxy