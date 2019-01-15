# 0800-VNS-IPANEMA_WAN_OPT

* **version:** 1.0.0
* **tags:** Infovista, WAN Optimization
* **requirements**: Nuage 5.3.2+
* **designer**: Roman Dodin

This lab demonstrates joint integration between Nuage Networks VNS and Infovista Ipanema. It consists of an emulated underlay called "Internet" and a demo Organization with a HQ and three branches.

Once the lab is deployed and configured a user will be able to test/educate/validate the following Ipanema features powered by Nuage Networks VNS:

* Application Visibility
* WAN Optimization
* Application Control

> Ipanema features are covered in details in the Infovista Ipanema Integration Guide compiled by Nuage Networks.

Once automatically deployed and configured the lab will conform to the following diagram:
![lab](https://gitlab.com/rdodin/pics/wikis/uploads/ee2663d7fb353bff87c9c56e0e184717/image.png)

The Headquarters site and branch offices are emulated using the [Branch-PC image](https://nuagenetworks.zendesk.com/hc/en-us/articles/360010244033) which allows us to generate and analyze traffic as well as run some real-world applications.

# Deployment
The deployment process is powered by [nuxctl](htpps://nuxctl.nuagex.io) CLI tool. All the infrastructure deployment will be completed once a user runs the lab template available in this repo:

```bash
# make sure to fill in your nuagex public key information in the lab template
# before running the command
nuxctl create-lab -l nuxctl_0800-vns-ipanema_wan_opt.yml --wait
```

# Configuration
When lab deployment is finished, proceed with automatic lab configuration. Lab configuration is saved in a set of [CATS](http://cats-docs.nuageteam.net) scripts contained in a [cats](./cats/) folder of this repo.

> **WARNING**: since Ipanema VNF requires a second disk to be added to the VNF image, a user won't be able to add it via lab template or NuageX GUI. Please consult with NuageX team to convert the regular NSG images to the VNF-capable ones when the lab is deployed.

## Variables file
The configuration variables are stored in a single [vars.robot](./cats/vars.robot) file and you need to fill in the values there on the lines marked with `TO_BE_FILLED_BY_A_USER` string. These variables are user-specific, therefore you need to fill them in before running the configuration scripts.

## Starting configuration process
The configuration process will handle all the heavy-lifting of the lab configuration. Starting with overlay objects creation, going through NSG boostrap and activation, finishing with VNFs creation and insertion policies configuration.

To launch the configuration sequence a user need to download CATS to their machine or use CATS in a container.

The following example start the whole configuration process using CATS installation on a users machine:

```bash
# being in the lab directory (where this README.md file is located)
# flags:
## -X -- stop the execution if error occurs

cats -X cats/
```

# Branch PCs
Branch-PCs are emulating branch clients and are Centos7 VMs with Gnome desktop. SSH access is made via jumpbox (i.e. `ssh centos@10.0.0.101`)

These PCs can also be accessed via RDP directly over internet:

* PC1: rdp://{lab_ip}:33891
* PC2: rdp://{lab_ip}:33892
* PC3: rdp://{lab_ip}:33893
* HQ-PC1: rdp://{lab_ip}:33899

More information on Branch-PC image can be found [here](https://nuagenetworks.zendesk.com/hc/en-us/articles/360010244033)

# Use cases

Use cases are to be provisioned by a user manually after lab configuration finishes. Check with the Infovista Ipanema Integration Guide for use cases configuration instructions.