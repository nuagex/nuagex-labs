The lab provides a simple 3-nodes Kubernetes cluster running on `Ubuntu 18.04` servers to practice Kubernetes skills or prepare for the CKA exam.

## Master and worker nodes configuration
Once the lab is deployed with `nuxctl` the three Ubuntu 18.04 VMs should be configured to act as a k8s master and worker nodes.

The repository contains two configuration scripts that will install the necessary k8s components and the Flannel CNI plugin. The `all_nodes.sh` script should be run first on all nodes:


```bash
# execute on every VM
# check the script contents to see what will be installed/configured on each node
curl -s https://raw.githubusercontent.com/nuagex/nuagex-labs/exfo/0900-CKA-UBUNTU/all_nodes.sh | bash
```

Then, on a master node only (lets assume the master is the first VM with the 10.0.0.2 IP address) execute the `master.sh` script:

```bash
# execute on master node only
curl -s https://raw.githubusercontent.com/nuagex/nuagex-labs/exfo/0900-CKA-UBUNTU/master.sh | bash
```

The result of the `master.sh` command is the `join` command string that you need to run with sudo privileges on the worker nodes. for example:

```bash
# on node1/2
# note, your string will be different, check the output of the `master.sh` command
sudo kubeadm join 10.0.0.2:6443 --token 6gneym.45l4102hvgz4jmac --discovery-token-ca-cert-hash sha256:53f5c0a2a72a436eed3ac320f531e96bafbab0f082f23063279a2c7c01c85c7a
```

This will enable your cluster and join nodes to the master. This can be verified with:
```
ubuntu@master:~$ kubectl get nodes
NAME     STATUS   ROLES    AGE   VERSION
master   Ready    master   70m   v1.12.2
node1    Ready    <none>   69m   v1.12.2
node2    Ready    <none>   69m   v1.12.2
```