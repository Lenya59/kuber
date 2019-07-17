#!/bin/bash

# BEGIN ########################################################################
echo -e "------------------------\n"
echo -e "---BEGIN BOOTSTRAPING---\n"
echo -e "------------------------\n"

sudo yum update -y
sudo yum upgrade -y
sudo yum install -y bind-utils net-tools git  mc htop mtr wget vim

# Disable swap
sudo swapoff -a

bash -c "cat  << EOF >> /etc/sysctl.conf
vm.swappiness=0
EOF"
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# install required docker packages
echo -e "Install required packages"
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

# add docker repository
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

#Install docker 18.6.1
echo -e "INSTALL DOCKER"
sudo yum update -y
sudo yum install -y docker-ce-18.06.1.ce docker-ce-cli-18.06.1.ce containerd.io --disableexcludes=docker

# Launch docker vithout sudo
sudo usermod -aG docker $(whoami)

sudo systemctl daemon-reload
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker

# Install Kubernetes 1.11.10
echo -e "-- add the Kubernetes repository"
cat << EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Turn off selinux.
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Configure sysctl
cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

echo -e "INSTALL KUBERNETES"
sudo yum install -y kubelet-1.11.10 kubeadm-1.11.10 kubectl-1.11.10 --disableexcludes=kubernetes

sudo systemctl enable kubelet
sudo systemctl start kubelet
sudo systemctl status kubelet


#Kubernetes cluster initialization
echo -e "---------------------------------------\n"
echo -e "---Kubernetes cluster initialization---\n"
echo -e "---------------------------------------\n"

ipaddr=$(ifconfig eth1 | grep inet | awk '{print $2}' | cut -d: -f2)
echo $ipaddr
sudo kubeadm init --apiserver-advertise-address=${ipaddr} --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all
mkdir -p -v $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config
cat $HOME/.kube/config
sudo kubeadm token create --print-join-command > /vagrant/nodeadd.sh
chmod 700 /vagrant/nodeadd.sh
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml

sudo reboot now
