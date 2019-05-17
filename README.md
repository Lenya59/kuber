# kuber

Hello!! Here you can find small kubernetes cluster))

To init Kube master node :

```shel
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

You can see that your master node initialized:

```shel
Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join 10.128.236.101:6443 --token ekdujl.ep8s2eyxk808dk9y --discovery-token-ca-cert-hash sha256:f489839ad13b9431dbf2b1d6bb700039dd870ef0269a7bdd5627fea82e7e2779
```
