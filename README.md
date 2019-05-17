# kuber

Hello!! Here you can find small kubernetes-cluster project))

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



First node joined cluster:
```shell
sudo kubeadm join 10.128.236.101:6443 --token ekdujl.ep8s2eyxk808dk9y --discovery-token-ca-cert-hash sha256:f489839ad13b9431dbf2b1d6bb700039dd870ef0269a7bdd5627fea82e7e2779
[preflight] running pre-flight checks
        [WARNING RequiredIPVSKernelModulesAvailable]: the IPVS proxier will not be used, because the following required kernel modules are not loaded: [ip_vs_rr ip_vs_wrr ip_vs_sh ip_vs] or no builtin kernel ipvs support: map[nf_conntrack_ipv4:{} ip_vs:{} ip_vs_rr:{} ip_vs_wrr:{} ip_vs_sh:{}]
you can solve this problem with following methods:
 1. Run 'modprobe -- ' to load missing kernel modules;
2. Provide the missing builtin kernel ipvs support

I0517 14:24:17.869122   23752 kernel_validator.go:81] Validating kernel version
I0517 14:24:17.869179   23752 kernel_validator.go:96] Validating kernel config
        [WARNING SystemVerification]: docker version is greater than the most recently validated version. Docker version: 18.06.1-ce. Max validated version: 17.03
[discovery] Trying to connect to API Server "10.128.236.101:6443"
[discovery] Created cluster-info discovery client, requesting info from "https://10.128.236.101:6443"
[discovery] Requesting info from "https://10.128.236.101:6443" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "10.128.236.101:6443"
[discovery] Successfully established connection with API Server "10.128.236.101:6443"
[kubelet] Downloading configuration for the kubelet from the "kubelet-config-1.11" ConfigMap in the kube-system namespace
[kubelet] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[preflight] Activating the kubelet service
[tlsbootstrap] Waiting for the kubelet to perform the TLS Bootstrap...
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "kuberwork1" as an annotation

This node has joined the cluster:
* Certificate signing request was sent to master and a response
  was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the master to see this node join the cluster.
```
You can add many nodes to your cluster, in our case it would be 2 nodes. When you done with your nodes you can check nodes in your cluster:
```shell
kubectl get nodes
```
I am get this:

```shell
[vagrant@kubeman ~]$ kubectl get nodes
NAME         STATUS     ROLES     AGE       VERSION
kubeman      NotReady   master    39m       v1.11.10
kuberwork1   NotReady   <none>    2m        v1.11.10
kuberwork2   NotReady   <none>    49s       v1.11.10
```
