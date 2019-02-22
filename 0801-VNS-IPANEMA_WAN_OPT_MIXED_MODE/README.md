# 0801-VNS-IPANEMA_WAN_OPT_MIXED_MODE

* **version:** 1.0.0
* **tags:** Infovista, WAN Optimization
* **requirements**: Nuage 5.3.2+
* **designer**: [Roman Dodin](mailto:roman.dodin@nokia.com)

This lab demonstrates a joint integration between Nuage Networks VNS and Infovista Ipanema solutions. The difference this lab has from the [0800-VNS-IPANEMA_WAN_OPT](../0800-VNS-IPANEMA_WAN_OPT) lab, is that it demonstrates how the Nuage Networks VNS can integrate with Infovista Ipanema, where existing sites are already using Ipanema Physical Appliances, hence the mixed deployment model name with virtual and physical Ipanema appliances.

Once the lab is deployed and configured, a user will be able to test/learn/validate the following Ipanema features powered by Nuage Networks VNS:

* Application Visibility
* WAN Optimization
* Application Control

> Ipanema features are covered in great detail in the Nuage Networks & Infovista Ipanema [Integration Guide](http://bit.ly/nuage_ipanema_ig) developed by Nuage Networks.

# Lab topology
Once a lab is deployed and configured using automation scripts, it will match the following diagram:
![lab](https://www.lucidchart.com/publicSegments/view/5b512e4d-9075-4cfc-8ea5-03805917dde1/image.png)

The lab utilizes a single "Internet" underlay and a demo Organization with a HQ site and three branches, where the headquarter site uses Ipanema Physical Engine (IPE) and all of the other branches support Virtual Ipanema Engines (VIPEs).

The headquarters site user devices and branch offices user devices are emulated using the [Branch-PC image](https://nuagenetworks.zendesk.com/hc/en-us/articles/360010244033) which allows us to generate and analyze traffic as well as run some real-world applications.

# Deployment
The lab deployment process is powered by the [nuxctl](https://nuxctl.nuagex.io) CLI tool. All of the infrastructure deployment will be completed after a user runs the the tool against the [lab template](nuxctl_0801-vns-ipanema_wan_opt_mixed_mode.yml) supplied within this repo.

The lab template is based on the NuageX's **Nuage Networks 5.3.2 - VNS SD-WAN Portal 3.2.1** template and has additional infra components required to support the infovista integration and use-case demonstration.

```bash
# make sure to fill in your nuagex public key information in the lab template
# before running the command
nuxctl create-lab -l nuxctl_0801-vns-ipanema_wan_opt_mixed_mode.yml --wait
```

# Configuration
After the lab deployment is complete, proceed with automatic lab configuration. Lab configuration is saved in a set of [CATS](http://cats-docs.nuageteam.net) scripts contained in the [cats](./cats/) directory of this repo.

In order to pull the CATS container and this repository to the lab's jumpbox VM follow the steps below:

1. Login to the jumpbox VM using your nuagex ssh key
   ```
   ssh -i <path_to_your_nuagex_private_key> admin@<lab_public_ip>
   ```

2. Run the setup script on the jumpbox
   ```bash
   # being logged in to the jumpbox
   curl https://raw.githubusercontent.com/nuagex/nuagex-labs/master/0801-VNS-IPANEMA_WAN_OPT_MIXED_MODE/setup.sh | bash
   ```
3. You should have the CATS container pulled out and the nuagex-labs repository cloned to the home directory of the jumpbox VM.

> **WARNING**: since Ipanema VNF requires a second disk to be added to the VNF image, a standard user will not be able to add it via the standard lab template or NuageX GUI. Please consult with NuageX team on how to convert the regular NSG images to the VNF-capable ones when the lab is deployed (e-mail nuagex+infovista@nuagenetworks.net with your lab ID and request).

## Variables file
The configuration variables are stored in a single [vars.robot](./cats/vars.robot) file and you need to fill in the values there on the lines marked with `TO_BE_FILLED_BY_A_USER` string. These variables must be filled out before running the configuration scripts.

## Starting configuration process
The configuration process will handle all of the heavy-lifting of the lab configuration. Starting with overlay object creation as well as NSG bootstrapping and activation, finishing with the creation of VNFs and insertion policies.

To launch the configuration sequence proceed with the following command issued on the labs jumpbox VM:

```bash
# issued on the jumpbox VM
# flags
## -X -- stop the execution if error occurs
docker run -t \
  -v ${HOME}/.ssh:/root/.ssh \
  -v /home/admin/nuagex-labs/0801-VNS-IPANEMA_WAN_OPT_MIXED_MODE/cats:/home/tests \
  hellt/cats:5.3.2 -X /home/tests
```

### Ipanema Physical Engine configuration
Since the goal of this lab is to demonstrate how a physical Ipanema appliance can be used in a joint solution, the lab simulates a physical appliance using a virtual instance if Ipanema. Read more about it in a [separate documentation article](IPE_deployment.md).

# Branch PCs
Branch-PCs are emulating branch clients and are Centos7 VMs with Gnome desktop. SSH access to these machines is available via jumpbox VM (i.e. `ssh centos@10.0.0.101`, where `10.0.0.101` is the Branch-PC management address)

These PCs can also be accessed via RDP directly over internet:

* PC1: rdp://{lab_ip}:33891
* PC2: rdp://{lab_ip}:33892
* PC3: rdp://{lab_ip}:33893
* HQ-PC1: rdp://{lab_ip}:33899

More information on Branch-PC image can be found [here](https://nuagenetworks.zendesk.com/hc/en-us/articles/360010244033)

# Use cases

Use cases are to be provisioned by a the user manually after lab configuration completes. Check with the [Infovista Ipanema Integration Guide](http://bit.ly/nuage_ipanema_ig) for use case configuration instructions.
