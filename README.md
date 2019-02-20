# NuageX Labs
This repo contains Lab definition files and automation scripts designed to be used agains [NuageX](https://nuagex.io) platform.  
The catalog below lists the Labs available, dive into the appropriate folder to see what the lab is about and how to deploy it on NuageX.

Usually, Lab's automation harness leverages:

* [`nuxctl`](https://nuxctl.nuagex.io) to deploy the Nuage VSP components
* and [CATS](http://cats-docs.nuageteam.net) to configure the platform and the use cases

## Catalog

### [0010-VNS-BASIC](./0010-VNS-BASIC)
A VNS lab with a single VSD, VSC, two NSGs and Branch-PCs deployed inside the NuageX platform. Fully provisioned by CATS to the point where NSGs are bootstrap and ready to pass traffic.

### [0800-VNS-IPANEMA_WAN_OPT](./0800-VNS-IPANEMA_WAN_OPT)
Lab demonstrates a joint integration between Nuage Networks VNS and Infovista Ipanema solution. It consists of a single underlay and an Organization with a HQ and 3 sites. Ipanema features like Application Visibility, Application Control and WAN Optimization can be demonstrated using this lab.

### [0801-VNS-IPANEMA_WAN_OPT_MIXED_MODE](./0801-VNS-IPANEMA_WAN_OPT_MIXED_MODE)
Lab demonstrates a joint integration between Nuage Networks VNS and Infovista Ipanema solution. The difference this lab has from the [0800-VNS-IPANEMA_WAN_OPT](0800-VNS-IPANEMA_WAN_OPT) lab is that it demonstrates how the Nuage Networks VNS can integrate with Infovista Ipanema when there are sites in an existence that are using Ipanema Physical Appliances, hence the mixed deployment model name with virtual and physical Ipanema appliances.

### [0810-VNS-VIAVI_OBSERVER](./0810-VNS-VIAVI_OBSERVER)
Lab demonstrates joint integration between Nuage Networks VNS and [VIAVI Observer Live](https://www.viavisolutions.com/en-us/products/observerlive) solution. It consists of a single underlay and an Organization with a HQ and a branch site. Both HQ and a Branch are equipped with an NSG, which in turn runs VIAVI Virtual Agent as a Hosted VNF.

### [0900-CKA-UBUNTU](./0900-CKA-UBUNTU)
A 3-node kubernetes cluster (1 master and 2 nodes) running on Ubuntu 18.04 servers to practice with k8s or prepare for CKA exam.