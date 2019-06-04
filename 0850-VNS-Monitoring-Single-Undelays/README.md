# 0850-VNS-MONITORING-Single-Underlays

* **version:** 1.0.0
* **tags:** Monitoring
* **requirements**: Nuage 5.4.1+
* **designer**: Arun Poonia

This lab deploys a generic VNS lab with 3x NSG-Vs. The lab consists of an Organization comprised of a San Francisco HQ site, a Mountain View site and a New York Branch site that are deployed over a single underlay (Internet).

All branches are equipped with a single NSG, and each NSG has a single user-PC on the LAN subnet.

The automation harness provided with this lab enables a user to do any of the following:

* Demonstrate the SD-WAN Portal capabilities
* Using 3rd party monitoring tools to ingest flow data and objects from ES and VSD respectively

# 1 Lab topology and components

Once a lab is deployed and configured using automation scripts, it will match the following diagram:

![lab](./images/image.png)

The lab models an Organization with a headquarters (HQ) and a branch sites deployed over single underlay (Internet).

Both the HQ and the branchs are equipped with a Nuage Networks NSG. The headquarters site user devices and branch offices user devices are emulated using the [Branch-PC image](https://nuagenetworks.zendesk.com/hc/en-us/articles/360010244033) which allows to generate and analyze traffic as well as run some real-world applications. Although the devices are not needed to demonstrate the features of a joint solution, they are used here as the Installer PCs to automatically bootstrap the NSGs.

# Use cases

Provide a generic VNS monitoring setup that includes two NSG-Vs and PC behind each NSG. This setup can be used to showcase our SD-WAN portal and/or 3rd party monitoring (with a single underlay in this version of the lab). The focus will mainly be on API calls to both VSD and ES.

# Uses

Clone this repo locally to your machine and follow below sections carefully: 


```
 git clone https://github.com/nuagex/nuagex-labs.git
 git checkout liveaction
 cd 0830-VNS-Monitoring-Generic
```

> Note: Changes are not merged yet, so you will need to checkout `liveaction` branch to use this repo. 

# Deployment 

The lab is meant to be deployed on NuageX platform and is automated by the [nuxctl](https://nuxctl.nuagex.io) CLI tool. All of the infrastructure deployment will be completed after a user runs the the tool against the [lab template](nuxctl_0850-vns-monitoring_single_underlays.yml) supplied within this repo.

The lab is based on the NuageX's **Base VNS Template - 5.4.1 - Single Underlay** template and has additional infra components required to support the LiveAction integration and use case demonstration

## 2.1 Prerequisites
1. [Download](https://nuxctl.nuagex.io#download) `nuxctl` for your operating system.
2. Download the [nuxctl_0850-vns-monitoring_single_underlays](nuxctl_0850-vns-monitoring_single_underlays.yml) lab definition file created for this lab or clone this repository as a whole.
3. Replace the [public key](nuxctl_0850-vns-monitoring_single_underlays.yml#L7) in the lab definition file with the public key you have in your NuageX user account.

## 2.2 Starting deployment process
To initiate the deployment routine proceed with the following command:
```bash
# make sure to specify your nuagex public key in the lab template
# before running the command
nuxctl create-lab -l nuxctl_0850-vns-monitoring_single_underlays --wait
```

Once a deployment process ends successfully a user is presented with the parameters of a newly created lab. Take a note of the `Password` and `External IP` parameters as they will be referenced in the configuration process.

# 3 Configuration
After the lab deployment is complete, proceed with automatic lab configuration. Lab configuration is saved in a set of [CATS](http://cats-docs.nuageteam.net) scripts contained in the [cats](./cats/) directory of this repo.

The configuration is performed by the CATS tool running in a container on the lab's Jumpbox VM. 
1. Login to the jumpbox VM using your nuagex SSH key and the Lab's External IP.
   ```
   ssh -i <path_to_your_nuagex_private_key> admin@<lab_public_ip>
   ```
2. Clone Github repo on your jumpbox VM using below command:
   ```
   git clone https://github.com/nuagex/nuagex-labs.git
   ```

## 3.1 Starting configuration process
The configuration process will handle all of the heavy-lifting of the lab configuration. Starting with overlay object creation as well as NSG bootstrapping and activation, finishing with the creation of traffic scripts between NSGs PCs to support LiveAction traffic.

To launch the configuration sequence proceed with the following command issued on the labs jumpbox VM:

```bash
# issued on the jumpbox VM
# flags
## -X -- stop the execution on first error
docker run -t \
  -v ${HOME}/.ssh:/root/.ssh \
  -v /home/admin/nuagex-labs/0850-VNS-Monitoring-Single-Undelays/cats:/home/tests \
  nuagepartnerprogram/cats:5.4.1 -X /home/tests
```

Note, that in order to provide CATS container with passwordless access to the labs components the Jumpbox keys are shared with the container.  
Jumpbox's `${HOME}/.ssh` folder contents is exposed to the CATS container and mounted there by the `/root/.ssh` path. In effect, the `id_rsa` key on the Jumpbox will be available to the CATS container by the `/root/.ssh/id_rsa` path hence its configured on line [8](./cats/vars.robot#L8) of the variables file.


The configuration is successful if every step is marked with the green PASS status. The configuration execution log can be found under `cats/reports` directory (the full path is provided by CATS at the end of the execution output).

> Note, the automated lab configuration creates cronjobs on each PC on NSG side to support traffic scripts.

## 3.2 LiveSP Connection Details
Once installed you can connect to LiveSP GUI using `https://<jumpbox_ip>:2443` using `admin/admin` credentials. 

# 4 Troubleshooting


Every Lab configuration generates a report in the `cats/reports` directory, you can view the `output.xml` file to troubleshoot , if required.

- Make sure the key you are passing allows you to connect to Jumpbox VM using private key associated with your passed public key. This is mandatory.
- This script won't run if your are using any proxy to connect Jumpbox VM of your Lab. This is mandatory.
- You must update physical address on each NSG. Even though CATS scripts add NSG address please verify from Nuage Networks VSD that addresses are reflecting on Nuage Networks VSD.

## Feeback

Please send your feedback to nuagex@nuagenetworks.net
