#!/bin/bash

# BEGIN ########################################################################
echo -e "-- ------------------ --\n"
echo -e "-- BEGIN BOOTSTRAPING --\n"
echo -e "-- ------------------ --\n"

sudo yum update -y
sudo yum install -y bind-utils  net-tools git  mc htop mtr wget

sudo swapoff -a

# install required docker packages
echo -e "Install required packages"
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

# add docker repository
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo


# Configure sysctl
cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

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

echo -e "INSTALL KUBERNETES"
sudo yum install -y kubelet-1.11.10 kubeadm-1.11.10 kubectl-1.11.10 --disableexcludes=kubernetes

sudo systemctl enable kubelet
sudo systemctl start kubelet
sudo systemctl status kubelet
