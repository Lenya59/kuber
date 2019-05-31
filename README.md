# Kubernetes
  Hi to all!! Here you can find small kubernetes-cluster project, where we will set up cluster in an Ubuntu environment.
In this repository, we will briefly go through how to bootstrap a cluster and upgrading it using CentOS 7 servers.
## Cluster initialization
   So, I use the [vagrant](https://www.vagrantup.com/) for infrastructure deployment. In this repo you can find bootstrap files (kube_work.sh and kube_master.sh). They install docker-ce-18.06.1 and kubelete kubectl kubeadm --1.11.10. Much more information about installing you can find by links provided below.

[Installing kubeadm](https://kubernetes.io/docs/setup/independent/install-kubeadm/)

[Installing docker-ce](https://docs.docker.com/install/linux/docker-ce/centos/)

After bootstrapping we can start cluster initialization))

For initialization kubernetes master node :

```shell
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

You can see that your master node initialized:

```shell
[vagrant@kubemaster ~]$ sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=10.128.236.215
[init] using Kubernetes version: v1.11.10
[preflight] running pre-flight checks
I0531 10:54:14.813715    1074 kernel_validator.go:81] Validating kernel version
I0531 10:54:14.814016    1074 kernel_validator.go:96] Validating kernel config
        [WARNING SystemVerification]: docker version is greater than the most recently validated version. Docker version: 18.06.1-ce. Max validated version: 17.03
[preflight/images] Pulling images required for setting up a Kubernetes cluster
[preflight/images] This might take a minute or two, depending on the speed of your internet connection
[preflight/images] You can also perform this action in beforehand using 'kubeadm config images pull'
[kubelet] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[preflight] Activating the kubelet service
[certificates] Generated ca certificate and key.
[certificates] Generated apiserver certificate and key.
[certificates] apiserver serving cert is signed for DNS names [kubemaster kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 10.128.236.215]
[certificates] Generated apiserver-kubelet-client certificate and key.
[certificates] Generated sa key and public key.
[certificates] Generated front-proxy-ca certificate and key.
[certificates] Generated front-proxy-client certificate and key.
[certificates] Generated etcd/ca certificate and key.
[certificates] Generated etcd/server certificate and key.
[certificates] etcd/server serving cert is signed for DNS names [kubemaster localhost] and IPs [127.0.0.1 ::1]
[certificates] Generated etcd/peer certificate and key.
[certificates] etcd/peer serving cert is signed for DNS names [kubemaster localhost] and IPs [10.128.236.215 127.0.0.1 ::1]
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
[apiclient] All control plane components are healthy after 39.503287 seconds
[uploadconfig] storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.11" in namespace kube-system with the configuration for the kubelets in the cluster
[markmaster] Marking the node kubemaster as master by adding the label "node-role.kubernetes.io/master=''"
[markmaster] Marking the node kubemaster as master by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "kubemaster" as an annotation
[bootstraptoken] using token: clnw9g.yao8rbx8xxati3ck
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

  kubeadm join 10.128.236.215:6443 --token clnw9g.yao8rbx8xxati3ck --discovery-token-ca-cert-hash sha256:efc09c3c1b3f22d9ab22532c7b3ddd7b80a092c8ba25d1e6c416195f6140d322
```


Let's create supposing folders and add keys, do this only on the master node:

```shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
````

installing weave network as daemon-set

```shell
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
````

or you can Also install flannel networking:

```shell
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
```
If you wanna get more about CNI providers [get the link](https://chrislovecnm.com/kubernetes/cni/choosing-a-cni-provider/)

tip: you should add  --ignore-preflight-errors=all flag to join token command to force all errors(if you know what you do), or specify exact error which you need to ignore, in my case I got mismatch between docker and k8s versions, but really I know that they can work together :

```shell
sudo kubeadm join 10.0.2.15:6443 --token cbwnxb.lma8beckvbmw3wa4 --discovery-token-ca-cert-hash sha256:45efd59853773d1fdea3af388ecb5b138f1b5e2a671f02c1273b7bda2d4e5097 --ignore-preflight-errors=all
```


First node joined cluster:
```shell
[vagrant@kubework1 ~]$ kubeadm join 10.128.236.215:6443 --token clnw9g.yao8rbx8xxati3ck --discovery-token-ca-cert-hash sha256:efc09c3c1b3f22d9ab22532c7b3ddd7b80a092c8ba25d1e6c416195f6140d322
[preflight] running pre-flight checks
[preflight] Some fatal errors occurred:
        [ERROR IsPrivilegedUser]: user is not running as root
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
[vagrant@kubework1 ~]$ sudo kubeadm join 10.128.236.215:6443 --token clnw9g.yao8rbx8xxati3ck --discovery-token-ca-cert-hash sha256:efc09c3c1b3f22d9ab22532c7b3ddd7b80a092c8ba25d1e6c416195f6140d322
[preflight] running pre-flight checks
        [WARNING RequiredIPVSKernelModulesAvailable]: the IPVS proxier will not be used, because the following required kernel modules are not loaded: [ip_vs_rr ip_vs_wrr ip_vs_sh ip_vs] or no builtin kernel ipvs support: map[nf_conntrack_ipv4:{} ip_vs:{} ip_vs_rr:{} ip_vs_wrr:{} ip_vs_sh:{}]
you can solve this problem with following methods:
 1. Run 'modprobe -- ' to load missing kernel modules;
2. Provide the missing builtin kernel ipvs support

I0531 10:57:05.519917     815 kernel_validator.go:81] Validating kernel version
I0531 10:57:05.519979     815 kernel_validator.go:96] Validating kernel config
        [WARNING SystemVerification]: docker version is greater than the most recently validated version. Docker version: 18.06.1-ce. Max validated version: 17.03
[discovery] Trying to connect to API Server "10.128.236.215:6443"
[discovery] Created cluster-info discovery client, requesting info from "https://10.128.236.215:6443"
[discovery] Requesting info from "https://10.128.236.215:6443" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "10.128.236.215:6443"
[discovery] Successfully established connection with API Server "10.128.236.215:6443"
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

## Deployment
Let's continue and deploy nginx in our cluster.

We will deploy 4 replicas of nginx as service. A better way to do it, use declarative way which go along with writing yaml file for deployment.

YAML file presented below describe our deployment))

```yaml
---
apiVersion: apps/v1 #
kind: Deployment
metadata:
  name: nginx
  namespace: default
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 4 # tells deployment to run 1 pods matching the template
  template: # create pods using pod definition in this template
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: default
  labels:
    app: nginx
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx
  type: NodePort
  ```

When it done you can use:

```shell
kubectl apply -f https://raw.githubusercontent.com/Lenya59/kuber/master/deploy-nginx.yml
```


Let's check our pods and realize that 4 replicas of nginx done))

```shell
$ kubectl get pods
NAME                    READY     STATUS    RESTARTS   AGE
nginx-884c7fc54-677db   1/1       Running   0          48m
nginx-884c7fc54-89hn4   1/1       Running   0          48m
nginx-884c7fc54-l9cp4   1/1       Running   0          48m
nginx-884c7fc54-tdswr   1/1       Running   0          48m
```

You can check that NodePort take 31372 port to our service:

```shell
kubectl get all -o wide
NAME                        READY     STATUS    RESTARTS   AGE       IP          NODE        NOMINATED NODE
pod/nginx-884c7fc54-677db   1/1       Running   0          53m       10.44.0.2   kubework1   <none>
pod/nginx-884c7fc54-89hn4   1/1       Running   0          53m       10.44.0.1   kubework1   <none>
pod/nginx-884c7fc54-l9cp4   1/1       Running   0          53m       10.36.0.4   kubework2   <none>
pod/nginx-884c7fc54-tdswr   1/1       Running   0          53m       10.36.0.3   kubework2   <none>

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE       SELECTOR
service/http         ClusterIP   10.110.203.93   172.17.0.47   8000/TCP       1d        run=http
service/kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        3d        <none>
service/nginx        NodePort    10.105.31.48    <none>        80:31372/TCP   1h        app=nginx

NAME                    DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE       CONTAINERS   IMAGES         SELECTOR
deployment.apps/nginx   4         4         4            4           1h        nginx        nginx:latest   app=nginx

NAME                              DESIRED   CURRENT   READY     AGE       CONTAINERS   IMAGES         SELECTOR
replicaset.apps/nginx-884c7fc54   4         4         4         53m       nginx        nginx:latest   app=nginx,pod-template-hash=440739710
replicaset.apps/nginx-966857787   0         0         0         1h        nginx        nginx          app=nginx,pod-template-hash=522413343
```

There are too much ways to check if it work. I am check IP-kuberworker1:port of my machine:

![nginx-start-page](https://user-images.githubusercontent.com/30426958/58332907-ee283880-7e44-11e9-8439-38041443afa2.png)




Next step is upgrading our cluster from v1.11 to v1.12  [docs](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade-1-12/)

## Upgrading kubeadm clusters from v1.11 to v1.12


1.First step is upgrading kubeadm:

```shell
 yum upgrade -y kubeadm-1.12.9 --disableexcludes=kubernetes
Loaded plugins: fastestmirror
You need to be root to perform this command.
[vagrant@kubemaster ~]$ sudo !!
sudo yum upgrade -y kubeadm-1.12.9 --disableexcludes=kubernetes
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: centos.colocall.net
 * extras: centos.colocall.net
 * updates: centos.colocall.net
base                                                                                                                                                                                                                    | 3.6 kB  00:00:00
docker-ce-stable                                                                                                                                                                                                        | 3.5 kB  00:00:00
extras                                                                                                                                                                                                                  | 3.4 kB  00:00:00
kubernetes/signature                                                                                                                                                                                                    |  454 B  00:00:00
kubernetes/signature                                                                                                                                                                                                    | 1.4 kB  00:00:00 !!! updates                                                                                                                                                                                                                 | 3.4 kB  00:00:00
(1/3): extras/7/x86_64/primary_db                                                                                                                                                                                       | 200 kB  00:00:00
(2/3): updates/7/x86_64/primary_db                                                                                                                                                                                      | 5.0 MB  00:00:00
(3/3): kubernetes/primary                                                                                                                                                                                               |  49 kB  00:00:00
kubernetes                                                                                                                                                                                                                             354/354 Resolving Dependencies
--> Running transaction check
---> Package kubeadm.x86_64 0:1.11.10-0 will be updated
---> Package kubeadm.x86_64 0:1.12.9-0 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

=============================================================================================================================================================================================================================================== Package                                                  Arch                                                    Version                                                    Repository                                                   Size ===============================================================================================================================================================================================================================================Updating:
 kubeadm                                                  x86_64                                                  1.12.9-0                                                   kubernetes                                                  7.2 M

Transaction Summary
===============================================================================================================================================================================================================================================Upgrade  1 Package

Total download size: 7.2 M
Downloading packages:
No Presto metadata available for kubernetes
45586bda53ff222d2b6757d2d5a2e3f650ac3fe54b1c39f789bee2b4ecb242ba-kubeadm-1.12.9-0.x86_64.rpm                                                                                                                            | 7.2 MB  00:00:01
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : kubeadm-1.12.9-0.x86_64                                                                                                                                                                                                     1/2
  Cleanup    : kubeadm-1.11.10-0.x86_64                                                                                                                                                                                                    2/2
  Verifying  : kubeadm-1.12.9-0.x86_64                                                                                                                                                                                                     1/2
  Verifying  : kubeadm-1.11.10-0.x86_64                                                                                                                                                                                                    2/2

Updated:
  kubeadm.x86_64 0:1.12.9-0

Complete!
```

#### Check it :

```shell
 kubeadm version --output=yaml
clientVersion:
  buildDate: 2019-05-27T16:05:48Z
  compiler: gc
  gitCommit: e09f5c40b55c91f681a46ee17f9bc447eeacee57
  gitTreeState: clean
  gitVersion: v1.12.9
  goVersion: go1.10.8
  major: "1"
  minor: "12"
  platform: linux/amd64
```

2.On the master node run:  ```sudo kubeadm upgrade plan```

```shell
[vagrant@kubemaster ~]$ sudo kubeadm upgrade plan
[preflight] Running pre-flight checks.
[upgrade] Making sure the cluster is healthy:
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: v1.11.10
[upgrade/versions] kubeadm version: v1.12.9
I0530 08:31:47.135098   13172 version.go:236] remote version is much newer: v1.14.2; falling back to: stable-1.12
[upgrade/versions] Latest stable version: v1.12.9
[upgrade/versions] Latest version in the v1.11 series: v1.11.10

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   CURRENT        AVAILABLE
Kubelet     3 x v1.11.10   v1.12.9

Upgrade to the latest stable version:

COMPONENT            CURRENT    AVAILABLE
API Server           v1.11.10   v1.12.9
Controller Manager   v1.11.10   v1.12.9
Scheduler            v1.11.10   v1.12.9
Kube Proxy           v1.11.10   v1.12.9
CoreDNS              1.1.3      1.2.2
Etcd                 3.2.18     3.2.24

You can now apply the upgrade by executing the following command:

        kubeadm upgrade apply v1.12.9

_____________________________________________________________________
```
This command checks that your cluster can be upgraded, and fetches the versions you can upgrade to.


3.Choose a version to upgrade to, and run the appropriate command. For example:

```shell
 kubeadm upgrade apply v1.12.9
```

```shell
[vagrant@kubemaster ~]$ sudo kubeadm upgrade apply v1.12.9
[preflight] Running pre-flight checks.
[upgrade] Making sure the cluster is healthy:
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[upgrade/apply] Respecting the --cri-socket flag that is set with higher priority than the config file.
[upgrade/version] You have chosen to change the cluster version to "v1.12.9"
[upgrade/versions] Cluster version: v1.11.10
[upgrade/versions] kubeadm version: v1.12.9
[upgrade/confirm] Are you sure you want to proceed with the upgrade? [y/N]: y
[upgrade/prepull] Will prepull images for components [kube-apiserver kube-controller-manager kube-scheduler etcd]
[upgrade/prepull] Prepulling image for component etcd.
[upgrade/prepull] Prepulling image for component kube-apiserver.
[upgrade/prepull] Prepulling image for component kube-controller-manager.
[upgrade/prepull] Prepulling image for component kube-scheduler.
[apiclient] Found 1 Pods for label selector k8s-app=upgrade-prepull-kube-scheduler
[apiclient] Found 1 Pods for label selector k8s-app=upgrade-prepull-kube-controller-manager
[apiclient] Found 1 Pods for label selector k8s-app=upgrade-prepull-kube-apiserver
[apiclient] Found 1 Pods for label selector k8s-app=upgrade-prepull-etcd
[upgrade/prepull] Prepulled image for component kube-apiserver.
[upgrade/prepull] Prepulled image for component kube-scheduler.
[upgrade/prepull] Prepulled image for component kube-controller-manager.
[upgrade/prepull] Prepulled image for component etcd.
[upgrade/prepull] Successfully prepulled the images for all the control plane components
[upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.12.9"...
Static pod: kube-apiserver-kubemaster hash: 936a7305e045e958b5f3c0a7dd0b0d59
Static pod: kube-controller-manager-kubemaster hash: 4f3f3c092dc0df5cf7db499ce0ab3362
Static pod: kube-scheduler-kubemaster hash: d59e864ca2a56ad458586c81f2c04070
Static pod: etcd-kubemaster hash: 07458cfb6bbf9a64e2df25158b72b3a5
[etcd] Wrote Static Pod manifest for a local etcd instance to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests055147921/etcd.yaml"
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/etcd.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2019-05-30-08-35-17/etcd.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s
Static pod: etcd-kubemaster hash: 07458cfb6bbf9a64e2df25158b72b3a5
Static pod: etcd-kubemaster hash: 07458cfb6bbf9a64e2df25158b72b3a5
Static pod: etcd-kubemaster hash: de609d0d94ff2987bf30ca8c4b9664d6
[apiclient] Found 1 Pods for label selector component=etcd
[upgrade/staticpods] Component "etcd" upgraded successfully!
[upgrade/etcd] Waiting for etcd to become available
[util/etcd] Waiting 0s for initial delay
[util/etcd] Attempting to see if all cluster endpoints are available 1/10
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests055147921"
[controlplane] wrote Static Pod manifest for component kube-apiserver to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests055147921/kube-apiserver.yaml"
[controlplane] wrote Static Pod manifest for component kube-controller-manager to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests055147921/kube-controller-manager.yaml"
[controlplane] wrote Static Pod manifest for component kube-scheduler to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests055147921/kube-scheduler.yaml"
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-apiserver.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2019-05-30-08-35-17/kube-apiserver.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s
Static pod: kube-apiserver-kubemaster hash: 936a7305e045e958b5f3c0a7dd0b0d59
Static pod: kube-apiserver-kubemaster hash: 936a7305e045e958b5f3c0a7dd0b0d59
Static pod: kube-apiserver-kubemaster hash: 936a7305e045e958b5f3c0a7dd0b0d59
Static pod: kube-apiserver-kubemaster hash: 936a7305e045e958b5f3c0a7dd0b0d59
Static pod: kube-apiserver-kubemaster hash: 936a7305e045e958b5f3c0a7dd0b0d59
Static pod: kube-apiserver-kubemaster hash: 0c53952f65f83445c1677bebc72797a7
[apiclient] Found 1 Pods for label selector component=kube-apiserver
[upgrade/staticpods] Component "kube-apiserver" upgraded successfully!
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-controller-manager.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2019-05-30-08-35-17/kube-controller-manager.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s
Static pod: kube-controller-manager-kubemaster hash: 4f3f3c092dc0df5cf7db499ce0ab3362
Static pod: kube-controller-manager-kubemaster hash: a959ceeb5f59f2526f5e3974f6d703de
[apiclient] Found 1 Pods for label selector component=kube-controller-manager
[upgrade/staticpods] Component "kube-controller-manager" upgraded successfully!
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-scheduler.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2019-05-30-08-35-17/kube-scheduler.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s
Static pod: kube-scheduler-kubemaster hash: d59e864ca2a56ad458586c81f2c04070
Static pod: kube-scheduler-kubemaster hash: a1bccf6df549a8f3f7917df12e8c6750
[apiclient] Found 1 Pods for label selector component=kube-scheduler
[upgrade/staticpods] Component "kube-scheduler" upgraded successfully!
[uploadconfig] storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.12" in namespace kube-system with the configuration for the kubelets in the cluster
[kubelet] Downloading configuration for the kubelet from the "kubelet-config-1.12" ConfigMap in the kube-system namespace
[kubelet] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "kubemaster" as an annotation
[bootstraptoken] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstraptoken] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstraptoken] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.12.9". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.
```


## Upgrade master packages

3. Prepare master node for maintenance, making it unschedulable and evicting the workloads:

```shell
kubectl drain $NODE --ignore-daemonsets
```

```shell
[vagrant@kubemaster ~]$ kubectl drain kubemaster --ignore-daemonsets
node/kubemaster cordoned
WARNING: Ignoring DaemonSet-managed pods: kube-proxy-bm477, weave-net-kktvw
pod/coredns-576cbf47c7-fkmtq evicted
pod/coredns-576cbf47c7-jrhmv evicted
```

```shell
[vagrant@kubemaster ~]$ sudo yum upgrade -y kubelet-1.12.9 kubectl-1.12.9 --disableexcludes=kubernetes
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: centos.colocall.net
 * extras: centos.colocall.net
 * updates: centos.colocall.net
Resolving Dependencies
--> Running transaction check
---> Package kubeadm.x86_64 0:1.12.9-0 will be updated
---> Package kubeadm.x86_64 0:1.14.2-0 will be an update
---> Package kubelet.x86_64 0:1.11.10-0 will be updated
---> Package kubelet.x86_64 0:1.12.9-0 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

=============================================================================================================================================================================================================================================== Package                                                  Arch                                                    Version                                                    Repository                                                   Size ===============================================================================================================================================================================================================================================Updating:
 kubeadm                                                  x86_64                                                  1.14.2-0                                                   kubernetes                                                  8.7 M  kubelet                                                  x86_64                                                  1.12.9-0                                                   kubernetes                                                   19 M

Transaction Summary
===============================================================================================================================================================================================================================================Upgrade  2 Packages

Total download size: 28 M
Downloading packages:
No Presto metadata available for kubernetes
(1/2): de639995840837d724cc5a4816733d5aef5a6bf384eaff22c786def53fb4e1d5-kubeadm-1.14.2-0.x86_64.rpm                                                                                                                     | 8.7 MB  00:00:01
(2/2): 9be86d0b5cba4464d0c4094ba414613776a0813673a5eea3dd6cfbfce4946b8f-kubelet-1.12.9-0.x86_64.rpm                                                                                                                     |  19 MB  00:00:04
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Total                                                                                                                                                                                                          6.8 MB/s |  28 MB  00:00:04
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : kubelet-1.12.9-0.x86_64                                                                                                                                                                                                     1/4
  Updating   : kubeadm-1.14.2-0.x86_64                                                                                                                                                                                                     2/4
  Cleanup    : kubeadm-1.12.9-0.x86_64                                                                                                                                                                                                     3/4
  Cleanup    : kubelet-1.11.10-0.x86_64                                                                                                                                                                                                    4/4
  Verifying  : kubelet-1.12.9-0.x86_64                                                                                                                                                                                                     1/4
  Verifying  : kubeadm-1.14.2-0.x86_64                                                                                                                                                                                                     2/4
  Verifying  : kubelet-1.11.10-0.x86_64                                                                                                                                                                                                    3/4
  Verifying  : kubeadm-1.12.9-0.x86_64                                                                                                                                                                                                     4/4

Updated:
  kubeadm.x86_64 0:1.14.2-0                                                                                              kubelet.x86_64 0:1.12.9-0

Complete!
```

Prepare each node for maintenance

```shell 
[vagrant@kubemaster ~]$ kubectl drain kubework1 --ignore-daemonsets
node/kubework1 already cordoned
WARNING: Ignoring DaemonSet-managed pods: kube-proxy-ndznm, weave-net-644t6
pod/nginx-884c7fc54-89hn4 evicted
pod/nginx-884c7fc54-677db evicted
pod/nginx-884c7fc54-wzngn evicted
pod/nginx-884c7fc54-4x2fz evicted
pod/nginx-84c547cff9-qvzvq evicted
pod/coredns-576cbf47c7-ljzlv evicted
pod/coredns-576cbf47c7-rhmcb evicted
```

 Upgrade the Kubernetes package version on each master node first:
 
 ```shell
 yum upgrade -y kubelet-1.12.9 kubectl-1.12.9 --disableexcludes=kubernetes
 ```
```
* Restart the kubelet process:
```shell
sudo systemctl daemon-reload

kubectl uncordon kubemaster

kubectl get nodes
```
![master-updated](https://user-images.githubusercontent.com/30426958/58705149-fc330780-83b6-11e9-9673-7720b1944ebc.png)




 







