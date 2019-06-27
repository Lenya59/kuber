# Version of kubectl in --yaml format
kubectl version --output=yaml

kubeadm version --output=yaml


sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=10.128.236.242  --ignore-preflight-errors=all


yum upgrade -y kubeadm-1.12.9 --disableexcludes=kubernetes


yum upgrade -y kubelet-1.12.9 kubectl-1.12.9 --disableexcludes=kubernetes

yum upgrade -y kubelet-1.12.x kubeadm-1.12.x --disableexcludes=kubernetes




sudo systemctl daemon-reload

sudo systemctl status kubelet

#drain worker node
kubectl drain kubework1 --ignore-daemonsets


# Generate token for add nodes
kubeadm token create --print-join-command

# delete node from cluster
kubectl delete node <your_node_for_delete>
