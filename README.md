# Kubernetes

  Hi to all!! Here you can find small kubernetes-cluster project, where we will set up cluster in an Ubuntu environment. 
In this repository, we will briefly go through how to bootstrap a cluster using CentOS 7 servers.

   So, i use the [vagrant](https://www.vagrantup.com/) for infrastructure deployment. In this repo you can find bootstrap files (kube_work.sh and kube_master.sh). They install docker-ce-18.06.1 and kubelete kubectl kubeadm --1.11.10. Much more information about installing you can find by links provided below.

[Installing kubeadm](https://kubernetes.io/docs/setup/independent/install-kubeadm/)

[Installing docker-ce](https://docs.docker.com/install/linux/docker-ce/centos/)

After bootstrapping we can start cluster initialization))

To init kubenetes master node :
```shel
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

You can see that your master node initialized:

```shel
[vagrant@kubemaster ~]$ sudo kubeadm init --pod-network-cidr=10.244.0.0/16
[init] using Kubernetes version: v1.11.10
[preflight] running pre-flight checks
I0521 12:13:59.095228   32722 kernel_validator.go:81] Validating kernel version
I0521 12:13:59.095280   32722 kernel_validator.go:96] Validating kernel config
        [WARNING SystemVerification]: docker version is greater than the most recently validated version. Docker version: 18.06.1-ce. Max validated version: 17.03
[preflight/images] Pulling images required for setting up a Kubernetes cluster
[preflight/images] This might take a minute or two, depending on the speed of your internet connection
[preflight/images] You can also perform this action in beforehand using 'kubeadm config images pull'
[kubelet] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[preflight] Activating the kubelet service
[certificates] Generated ca certificate and key.
[certificates] Generated apiserver certificate and key.
[certificates] apiserver serving cert is signed for DNS names [kubemaster kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 10.0.2.15]
[certificates] Generated apiserver-kubelet-client certificate and key.
[certificates] Generated sa key and public key.
[certificates] Generated front-proxy-ca certificate and key.
[certificates] Generated front-proxy-client certificate and key.
[certificates] Generated etcd/ca certificate and key.
[certificates] Generated etcd/server certificate and key.
[certificates] etcd/server serving cert is signed for DNS names [kubemaster localhost] and IPs [127.0.0.1 ::1]
[certificates] Generated etcd/peer certificate and key.
[certificates] etcd/peer serving cert is signed for DNS names [kubemaster localhost] and IPs [10.0.2.15 127.0.0.1 ::1]
[certificates] Generated etcd/healthcheck-client certificate and key.
[certificates] Generated apiserver-etcd-client certificate and key.
[certificates] valid certificates and keys now exist in "/etc/kubernetes/pki"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/admin.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/kubelet.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/controller-manager.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/scheduler.conf"
[controlplane] wrote Static Pod manifest for component kube-apiserver to "/etc/kubernetes/manifests/kube-apiserver.yaml"
[controlplane] wrote Static Pod manifest for component kube-controller-manager to "/etc/kubernetes/manifests/kube-controller-manager.yaml"
[controlplane] wrote Static Pod manifest for component kube-scheduler to "/etc/kubernetes/manifests/kube-scheduler.yaml"
[etcd] Wrote Static Pod manifest for a local etcd instance to "/etc/kubernetes/manifests/etcd.yaml"
[init] waiting for the kubelet to boot up the control plane as Static Pods from directory "/etc/kubernetes/manifests"
[init] this might take a minute or longer if the control plane images have to be pulled
[apiclient] All control plane components are healthy after 39.513188 seconds
[uploadconfig] storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.11" in namespace kube-system with the configuration for the kubelets in the cluster
[markmaster] Marking the node kubemaster as master by adding the label "node-role.kubernetes.io/master=''"
[markmaster] Marking the node kubemaster as master by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "kubemaster" as an annotation
[bootstraptoken] using token: lpap42.buvp0htiwqra88k1
[bootstraptoken] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstraptoken] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstraptoken] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstraptoken] creating the "cluster-info" ConfigMap in the "kube-public" namespace
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

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

  kubeadm join 10.0.2.15:6443 --token lpap42.buvp0htiwqra88k1 --discovery-token-ca-cert-hash sha256:45efd59853773d1fdea3af388ecb5b138f1b5e2a671f02c1273b7bda2d4e5097
```
Let's create supposig folders and add keys, do this only on the master node:
```shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
````

installing weave network as daemonset

```shell
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
````

or youy can Also install flannel networking:
```shell
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
```
If you wanna get more about CNI providers, [get the link](https://chrislovecnm.com/kubernetes/cni/choosing-a-cni-provider/)

tip: you shoud add  --ignore-preflight-errors=all flag to join token command to forse all errors(if you know what you do), or specify exact error which you need to ignore, in my case i got mismatch between docker and k8s versions, but really i know that they can work together :

```shell
sudo kubeadm join 10.0.2.15:6443 --token cbwnxb.lma8beckvbmw3wa4 --discovery-token-ca-cert-hash sha256:45efd59853773d1fdea3af388ecb5b138f1b5e2a671f02c1273b7bda2d4e5097 --ignore-preflight-errors=all
```


First node joined cluster:
```shell
[vagrant@kubework1 ~]$ sudo kubeadm join 10.128.236.65:6443 --token 8etlu1.ixweb7gpuq7cb3r6 --discovery-token-ca-cert-hash sha256:79ca91bd422aad9a2f09960cb83a483d5f8d55104852b38060f08414edea0a14
[preflight] running pre-flight checks
        [WARNING RequiredIPVSKernelModulesAvailable]: the IPVS proxier will not be used, because the following required kernel modules are not loaded: [ip_vs ip_vs_rr ip_vs_wrr ip_vs_sh] or no builtin kernel ipvs support: map[ip_vs:{} ip_vs_rr:{} ip_vs_wrr:{} ip_vs_sh:{} nf_conntrack_ipv4:{}]
you can solve this problem with following methods:
 1. Run 'modprobe -- ' to load missing kernel modules;
2. Provide the missing builtin kernel ipvs support

I0521 13:39:20.907324   32139 kernel_validator.go:81] Validating kernel version
I0521 13:39:20.907394   32139 kernel_validator.go:96] Validating kernel config
        [WARNING SystemVerification]: docker version is greater than the most recently validated version. Docker version: 18.06.1-ce. Max validated version: 17.03
[discovery] Trying to connect to API Server "10.128.236.65:6443"
[discovery] Created cluster-info discovery client, requesting info from "https://10.128.236.65:6443"
[discovery] Requesting info from "https://10.128.236.65:6443" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "10.128.236.65:6443"
[discovery] Successfully established connection with API Server "10.128.236.65:6443"
[kubelet] Downloading configuration for the kubelet from the "kubelet-config-1.11" ConfigMap in the kube-system namespace
[kubelet] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[preflight] Activating the kubelet service
[tlsbootstrap] Waiting for the kubelet to perform the TLS Bootstrap...
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "kubework1" as an annotation

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
[vagrant@kubemaster ~]$ kubectl get nodes
NAME         STATUS    ROLES     AGE       VERSION
kubemaster   Ready     master    13m       v1.11.10
kubework1    Ready     <none>    12m       v1.11.10
kubework2    Ready     <none>    1m        v1.11.10
```
