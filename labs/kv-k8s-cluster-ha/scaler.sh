#!/usr/bin/env bash
# kuberverse kubernetes cluster lab
# version: 0.1.0-alpha
# description: this is the scaler (load balancer) script file
# created by Artur Scheiner - artur.scheiner@gmail.com

KVMSG=$1
SCALER_IP=$2
MASTER_IPS=$(echo $3 | sed -e 's/,//g' -e 's/\]//g' -e 's/\[//g')

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

apt-get update

apt-get install -y avahi-daemon libnss-mdns traceroute htop httpie bash-completion haproxy ruby docker-ce

cat >> /etc/haproxy/haproxy.cfg <<EOF
global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384

frontend kv-scaler
        bind *:6443
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
  echo "    server kv-master-$i $mips:6443 check" >> /etc/haproxy/haproxy.cfg
  ((i++))
done

# echo "#Added by Kuberverse" > /vagrant/hosts.out
# echo "$SCALER_IP     kv-scaler.lab.local     kv-scaler.local     kv-scaler" >> /vagrant/hosts.out

cat > /vagrant/hosts.out<<EOF
# Added by Kuberverse
$SCALER_IP     kv-scaler.lab.local     kv-scaler.local     kv-scaler
EOF

cat /vagrant/hosts.out >> /etc/hosts

systemctl restart haproxy