#!/bin/bash

# Stop and disable firewalld
echo "[TASK 1] Stop and Disable firewalld"
systemctl disable --now ufw >/dev/null 2>&1


# Disable swap
echo "[TASK 2] Disable and turn off SWAP"
swapoff -a
sed -i '/swap/d' /etc/fstab


# Add sysctl settings for k8s networking
echo "[TASK 4] Add sysctl settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system


# Enable and Load Kernel modules (conainerd prerequistes)
echo "[TASK 3] Enable and load kernel modules"
cat >> /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter


# Install and enable containerd
echo "[TASK 5] Install and enable containerd"
apt-get update
apt-get install -y containerd 
mkdir /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd



# Add apt repo file for Kubernetes
echo "[TASK 6] Add apt repo for kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"


#  Install kubelet, kubectl and Kubeadm
echo "[TASK 7] Install Kubernetes components (kubeadm, kubelet and kubectl)"
apt update
apt install -y kubeadm=1.22.0-00 kubelet=1.22.0-00 kubectl=1.22.0-00


# Start and Enable kubelet service
echo "[TASK 8] Enable and start kubelet service"
systemctl enable --now kubelet

# # Enable ssh password authentication
# echo "[TASK 10] Enable ssh password authentication"
# sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
# echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
# systemctl reload sshd

# # Set Root password
# echo "[TASK 11] Set root password"
# echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1

# # Update vagrant user's bashrc file
# echo "export TERM=xterm" >> /etc/bashrc

