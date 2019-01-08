# NuageX Labs
This repo contains Lab definition files and automation scripts designed to be used agains [NuageX](https://nuagex.io) platform.  
The catalog below lists the Labs available, dive into the appropriate folder to see what the lab is about and how to deploy it on NuageX.

Usually, Lab' automation harness leverages:

* [`nuxctl`](https://nuxctl.nuagex.io) to deploy the Nuage VSP components
* and [CATS](http://cats-docs.nuageteam.net) to configure the platform and the use cases

## Catalog

### [0010-VNS-BASIC](./0010-VNS-BASIC)
A VNS lab with a single VSD, VSC, two NSGs and Branch-PCs deployed inside the NuageX platform. Fully provisioned by CATS to the point where NSGs are bootstrap and ready to pass traffic.

### [0900-CKA-UBUNTU](./0900-CKA-UBUNTU)
A 3-node kubernetes cluster (1 master and 2 nodes) running on Ubuntu 18.04 servers to practice with k8s or prepare for CKA exam.