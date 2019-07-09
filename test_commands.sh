# Version of kubectl in --yaml format
kubectl version --output=yaml
kubectl version --output=json

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=10.128.236.242  --ignore-preflight-errors=all

yum upgrade -y kubeadm-1.12.9 --disableexcludes=kubernetes

yum upgrade -y kubelet-1.12.x kubeadm-1.12.x --disableexcludes=kubernetes


sudo systemctl daemon-reload

sudo systemctl status kubelet

#drain worker node
kubectl drain kubework1 --ignore-daemonsets


# Generate token for add nodes
kubeadm token create --print-join-command

# delete node from cluster
kubectl delete node <your_node_for_delete>


# Create an environment variable called NODE_PORT that has a value as the Node port
export NODE_PORT=$(kubectl get services/SVC_NAME -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT


sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=10.128.236.253  --ignore-preflight-errors=all

kubeadm join 10.128.236.253:6443 --token dwb532.4q9twnu9yo8bmpbq --discovery-token-ca-cert-hash sha256:9ace4fb38066338dc4ba0128e4b2e0f1dad4735cf47c530cd66def5ef83ceaad


# Changing the kubelet Configuration
# add this string to a worker nodes: 
# Environment="KUBELET_EXTRA_ARGS=--node-ip=<worker IP address>"
# 1 - 10.128.236.199
# 2 - 10.128.236.168
sudo vi /lib/systemd/system/kubelet.service.d/10-kubeadm.conf

sudo systemctl daemon-reload && sudo systemctl restart kubelet