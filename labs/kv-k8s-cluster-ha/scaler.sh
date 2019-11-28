#!/usr/bin/env bash
# kuberverse k8s lab provisioner scaler
# type: kubeadm-calico-full-cluster-bootstrap
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
  echo "    server kv-master-$i $mips:6443 check" >> /etc/haproxy/haproxy.cfg
  ((i++))
done

echo "# $KVMSG" > /vagrant/hosts.out
echo "$SCALER_IP     kv-scaler.lab.local     kv-scaler.local     kv-scaler" >> /vagrant/hosts.out

# cat > /vagrant/hosts.out<<EOF
# # $KVMSG
# $SCALER_IP     kv-scaler.lab.local     kv-scaler.local     kv-scaler
# EOF

cat /vagrant/hosts.out >> /etc/hosts

systemctl restart haproxy

cat >> /etc/kuberverse/kv-scaler/haproxy.cfg <<EOF
global
    #debug                          # uncomment to enable debug mode for HAProxy

defaults
    mode http                                # enable http mode which gives of layer 7 filtering
    timeout connect 5000ms                   # max time to wait for a connection attempt to a server to succeed
    timeout client 50000ms                   # max inactivity time on the client side
    timeout server 50000ms                   # max inactivity time on the server side

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

mkdir -p /etc/kuberverse/kv-scaler

cat > /etc/kuberverse/kv-scaler/Dockerfile<<EOF
FROM haproxy:1.7
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
EOF

cd /etc/kuberverse/kv-scaler
docker build -t kv-scaler .
docker run -d --name -p 8080:8080 kv-scaler kv-scaler:latest

cat > /etc/systemd/system/kv-scaler-docker.service<<EOF
[Unit]
Description=DokuWiki Container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a kv-scaler
ExecStop=/usr/bin/docker stop -t 2 kv-scaler

[Install]
WantedBy=local.target
EOF

systemctl daemon-reload
systemctl start kv-scaler-docker.service
systemctl enable kv-scaler-docker.service