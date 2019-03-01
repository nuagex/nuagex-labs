# 0801-VNS-IPANEMA_WAN_OPT_MIXED_MODE

* **version:** 1.0.0
* **tags:** Infovista, WAN Optimization
* **requirements**: Nuage 5.3.2+
* **designer**: [Roman Dodin](mailto:roman.dodin@nokia.com)

This lab demonstrates a joint integration between **Nuage Networks VNS** and **Infovista Ipanema** solutions. The difference this lab has from the [0800-VNS-IPANEMA_WAN_OPT](../0800-VNS-IPANEMA_WAN_OPT) lab, is that it demonstrates how the Nuage Networks VNS can integrate with Infovista Ipanema, where existing sites are already using Ipanema Physical Appliances. Hence the _mixed_ deployment model with both virtual and physical Ipanema appliances.

> **Note**, a user account in Infovista Ipanema SALSA management system is required to demonstrate the integration.

Once the lab is deployed and configured, a user will be able to test/learn/demonstrate the following Ipanema features powered by Nuage Networks VNS:

* Application Visibility
* WAN Optimization
* Application Control

> Ipanema features are covered in great detail in the Nuage Networks & Infovista Ipanema [Integration Guide](http://bit.ly/nuage_ipanema_ig) developed by Nuage Networks.

# 1 Lab topology and components
Once a lab is deployed and configured using automation scripts, it will match the following diagram:

![lab](https://www.lucidchart.com/publicSegments/view/5b512e4d-9075-4cfc-8ea5-03805917dde1/image.png)

The lab utilizes a single "Internet" underlay and a demo Organization with a HQ site and three branches, where the headquarter site uses Ipanema Physical Engine (IPE) and all of the other branches support Virtual Ipanema Engines (VIPEs).

The headquarters site user devices and branch offices user devices are emulated using the [Branch-PC image](https://nuagenetworks.zendesk.com/hc/en-us/articles/360010244033) which allows us to generate and analyze traffic as well as run some real-world applications.

# 2 Deployment
The lab deployment process is powered by the [nuxctl](https://nuxctl.nuagex.io) CLI tool. All of the infrastructure deployment will be completed after a user runs the the tool against the [lab template](nuxctl_0801-vns-ipanema_wan_opt_mixed_mode.yml) supplied within this repo.

The lab template is based on the NuageX's **Nuage Networks 5.3.2 - VNS SD-WAN Portal 3.2.1** template and has additional infra components required to support the Infovista integration and use-case demonstration.

## 2.1 Prerequisites
1. [Download](https://nuxctl.nuagex.io#download) `nuxctl` for your operating system.
2. Download the [nuxctl_0801-vns-ipanema_wan_opt_mixed_mode.yml](nuxctl_0801-vns-ipanema_wan_opt_mixed_mode.yml) lab definition file created for this lab or clone this repository as a whole.
3. Replace the [public key](nuxctl_0801-vns-ipanema_wan_opt_mixed_mode.yml#L7) in the lab definition file with the public key you have in your NuageX user account.

## 2.2 Starting deployment process
To initiate the deployment routine proceed with the following command:

```bash
# make sure to fill in your nuagex public key information in the lab template
# before running the command
nuxctl create-lab -l nuxctl_0801-vns-ipanema_wan_opt_mixed_mode.yml --wait
```

Once a deployment process ends successfully a user is presented with the parameters of a newly created lab. Take a note of the `Password` and `External IP` parameters as they will be referenced in the configuration process.

# 3 Configuration
After the lab deployment is complete, proceed with automatic lab configuration. Lab configuration is saved in a set of [CATS](http://cats-docs.nuageteam.net) scripts contained in the [cats](./cats/) directory of this repo.

> **WARNING**: since Nuage Networks Hosted VNF feature requires a second disk to be added to the NSG-V image, a standard user will not be able to add it. Please contact the NuageX team on how to convert the regular NSG-V image to the VNF-capable one **before starting the configuration process** (e-mail nuagex+infovista@nuagenetworks.net with your lab ID and request).

The configuration is performed by the CATS tool running in a container on the lab's Jumpbox VM. In order to pull the CATS container and this repository to the lab's jumpbox VM follow the steps below:

1. Login to the jumpbox VM using your nuagex SSH key and the Lab's External IP.
   ```
   ssh -i <path_to_your_nuagex_private_key> admin@<lab_public_ip>
   ```

2. Pull down the CATS container and clone this repository by running the setup script with this command:
   ```bash
   # issued on the jumpbox
   curl https://raw.githubusercontent.com/nuagex/nuagex-labs/master/helpers/setup_5.3.2.sh | bash
   ```

## 3.1 Variables file
The configuration variables are stored in a single [vars.robot](./cats/vars.robot) file and you need to fill in the values there on the lines marked with `TO_BE_FILLED_BY_A_USER` string. These variables must be filled out before running the configuration scripts.

### 3.1.1 VSD login
Authentication and authorization with VSD is needed in order to configure objects via VSD API. Make sure to add the VSD password (obtained in the end of the deployment procedure) on line [105](./cats/vars.robot#L105) of the variables file.

### 3.1.2 VNF image path
The paths to the Ipanema VNF image and a corresponding md5 file should be provided by a user on lines [88-89](./cats/vars.robot#L88-L89). The automation scripts will download the image file and its checksum to the Util VM, which means that Util VM should have reachability to the data storage hosting these files.

You can [contact NuageX representatives](mailto:nuagex+ipanema@nuagenetworks.net) with the request to obtain the paths to these files.


## 3.2 Starting configuration process
The configuration process will handle all of the heavy-lifting of the lab configuration. Starting with overlay object creation as well as NSG bootstrapping and activation, finishing with the creation of VNFs and insertion policies.

To launch the configuration sequence proceed with the following command issued on the labs jumpbox VM:

```bash
# issued on the jumpbox VM
# flags
## -X -- stop the execution if error occurs
docker run -t \
  -v ${HOME}/.ssh:/root/.ssh \
  -v /home/admin/nuagex-labs/0801-VNS-IPANEMA_WAN_OPT_MIXED_MODE/cats:/home/tests \
  nuagepartnerprogram/cats:5.3.2 -X /home/tests
```

Note, that in order to provide CATS container with passwordless access to the labs components the Jumpbox keys are shared with the container.  
Jumpbox's `${HOME}/.ssh` folder contents is exposed to the CATS container and mounted there by the `/root/.ssh` path. In effect, the `id_rsa` key on the Jumpbox will be available to the CATS container by the `/root/.ssh/id_rsa` path hence its configured on line [104](./cats/vars.robot#L104) of the variables file.

> Note, the automated lab configuration does not create Ipanema appliances in the SALSA application, a user needs to manually create them and define the services after running the CATS scripts.

## 3.3 Ipanema Physical Engine configuration
Since the goal of this lab is to demonstrate how a physical Ipanema appliance can be used in a joint solution, the lab simulates a physical appliance using a virtual instance if Ipanema. Read more about it in a [separate documentation article](IPE_deployment.md).

# 4 Branch PCs
Branch-PCs are emulating branch clients and are Centos7 VMs with Gnome desktop. SSH access to these machines is available via jumpbox VM (i.e. `ssh centos@10.0.0.101`, where `10.0.0.101` is the Branch-PC management address)

These PCs can also be accessed via RDP directly over internet:

* PC1: rdp://{lab_ip}:33891
* PC2: rdp://{lab_ip}:33892
* PC3: rdp://{lab_ip}:33893
* HQ-PC1: rdp://{lab_ip}:33899

More information on Branch-PC image can be found [here](https://nuagenetworks.zendesk.com/hc/en-us/articles/360010244033)

# 5 Use cases

Use cases are to be provisioned by a the user manually after lab configuration completes. Check with the [Infovista Ipanema Integration Guide](http://bit.ly/nuage_ipanema_ig) for use case configuration instructions.
