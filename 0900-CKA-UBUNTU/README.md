The lab provides a simple 3-nodes kubernetes cluster running on Ubuntu 18.04 servers to practice with Kubernetes or prepare for the CKA exam.

## Nodes configuration
Once the lab is deployed with `nuxctl` the k8s nodes (one master and two nodes) should be configured with some initial commands:

Create a `setup.sh` file and include the following portion on all nodes:
```
# on all nodes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu kubelet=1.12.2-00 kubeadm=1.12.2-00 kubectl=1.12.2-00
sudo apt-mark hold docker-ce kubelet kubeadm kubectl

echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

Then, on a master node only, add the following lines
```
# on master
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
```

Execute the setup file on master first and then run it on the nodes.

When the script running on master finishes, you will get the `join` command string that you need to run with sudo on the nodes. for example:

```
# on node1/2
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