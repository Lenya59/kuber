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


sudo kubeadm init --pod-network-cidr=10.1.0.0/16 --apiserver-advertise-address=10.128.236.197  --ignore-preflight-errors=all

sudo kubeadm join 10.128.236.197:6443 --token 2dfupt.yqi7kfrza2jr9yb8 --discovery-token-ca-cert-hash sha256:19303757c0339e8149c3b5afedb0a7d52c7a237b0efaf52a15c8e1236ed870af --ignore-preflight-errors=all

# Changing the kubelet Configuration
# add this string to a worker nodes:
# Environment="KUBELET_EXTRA_ARGS=--node-ip=10.128.236.246"


sudo vi /lib/systemd/system/kubelet.service.d/10-kubeadm.conf

sudo systemctl daemon-reload && sudo systemctl restart kubelet

10.128.236.200 # kubework1
10.128.236.197 # master
10.128.236.246 # 2

kubectl config set-cluster demo-cluster --server=https://10.128.236.253:6443





kubeadm join 10.128.236.145:6443 --token yolljs.rheoo969xxco7pq4 --discovery-token-ca-cert-hash sha256:937ca786d573dec4493cfcdbfcfb17d62c601caf4c5aea1349ca3927e88d7342 --node-ip=10.128.236.249
