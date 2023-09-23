#!/bin/bash


# Install Haproxy
echo "[TASK 1] Install Haproxy"
apt update && apt install -y haproxy

# Configure haproxy
echo "[TASK 2] configure ha-proxy"
cat >> /etc/keepalived/keepalived.conf <<EOF
frontend kubernetes-frontend
    bind 172.16.16.100:6443
    mode tcp
    option tcplog
    default_backend kubernetes-backend

backend kubernetes-backend
    mode tcp
    option tcp-check
    balance roundrobin
    server kmaster1 172.16.16.101:6443 check fall 3 rise 2
    server kmaster2 172.16.16.102:6443 check fall 3 rise 2
EOF


# restart haproxy
echo "[TASK 3] restart ha-proxy"
systemctl restart haproxy
