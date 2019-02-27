# 0830-VNS-MONITORING-GENERIC

* **version:** 1.0.0
* **tags:** Monitoring
* **requirements**: Nuage 5.3.3+, Docker on local Machine, CATS container image available on local machine
* **designer**: Arun Poonia
* **validation**: Outside of NuageX lab

This lab deploys a generic VNS lab with NSG-Vs. The lab consists of an Organization comprised of a Mountain View and a New York Branch sites deployed over a single underlay (Internet).

Both Mountain View and New York branches are equipped with an NSG. Each NSG has one PC present on LAN subnet.

The automation harness provided with this lab enables a user to demonstrate the following use case:

* Bootstrapping NSG-Vs
* SD-WAN Portal

Once automatically deployed and configured the lab will conform to the following diagram:
![lab](./images/image.png)

The Mountain View site and New York branch offices are equipped with the [Branch-PC image](https://nuagenetworks.zendesk.com/hc/en-us/articles/360010244033) which allows to generate and analyze traffic as well as run some real-world applications.

# Use cases

Provide a generic VNS monitoring platform to allow two NSG-Vs and PC behind each NSG.

# Lab Deployment 

The lab deployment process is powered by [nuxctl](https://nuxctl.nuagex.io) CLI tool. The infrastructure deployment activities will be triggered once a user supply the lab template available in this repo to the `nuxctl` tool.

The lab template is based on the **Nuage Networks 5.3.3U3** NuageX template and has additional infra components defined to support the use case demonstration.

Follow below steps to deploy the lab:
1. Make sure you have installed `nuxctl` on your local machine. 
   - If not installed follow [nuxctl](https://nuxctl.nuagex.io) tool to install on your local machine
2. Update your `nuagex` username and password in [creds_file](./my_creds.yml) file.
3. Update `ssh-key` on line [7](./nuxctl_0830-vns-monitoring_generic.yml#L7)
4. Run below command to create lab: 
```bash
# make sure to fill in your nuagex public key information in the lab template
# before running the command
nuxctl create-lab -c my_creds.yml -l  nuxctl_0830-vns-monitoring_generic.yml --wait
```
5. On successfull completion you will see output similiar to this: 
```bash 

ID                        Name                    Status   Expires                 External IP      Password
------------------------  ----------------------  -------  ----------------------  ---------------  ----------------
<lab_id>                  vns-monitoring-labs     started  2019-02-23 00:31 (UTC)  XXXXXX           XXXXX
```
6. Note down `External IP` and `Password` which you will need in `Variables File` section. 

# CATS Docker Configuration 

To run CATS scripts on your lab, you will need to pull cats container image locally to your machine. 

1. Make sure docker is running on your machine. 
2. Pull CATS container image on your local mahcine: 
   - Command: `docker pull nuagepartnerprogram/cats:5.3.2` 
   - This will pull CATS container repo locally to your machine.

# Lab Configuration

When the lab deployment is finished, proceed with automatic lab configuration. 

1. Lab configuration automation is saved in a set of [CATS](http://cats-docs.nuageteam.net) scripts contained in a [cats](./cats/) folder of this repo.
2. You will need to update variables file located in the [vars.robot](./cats/vars.robot). You must update only variables which are marked with `TO_BE_FILLED_BY_A_USER` string and therefore must be provided by a user before running the configuration scripts: 
   - `Jumpbox` address of your NuageX lab deployed in previous section. 
   - `vsd_password` password associated with `admin` user of VSD UI. 
   - `ssh_key_path` full path of your private key associated with `public_key` 
   - Example: 
    
    ```bash 
    ##############################
    #     CONNECTION PARAMETERS
    ##############################
    ${jumpbox_address}                124.252.X.X
    ${vsd_password}                   XXXXXXXXXXXXXX
    ${ssh_key_path}                   ~/.ssh/id_rsa
    ```

3. Run your lab configuration using below command: 
   - Change your working directory to `0830-VNS-Monitoring-Generic` folder. 
   - You will be mounting your `private_key` path and current directory where `cats` scripts are stored.
   - Run below command to complete lab cofigruation. 

   ```bash
   # being in the lab directory (where this README.md file is located)
   # flags:
   ## -X -- stop the execution if error occurs
   ## -e solo_run -- exclude the test cases marked with `solo_run` tag

   docker run -t \
   -v ${HOME}/.ssh:/root/.ssh \
   -v `pwd`/cats:/home/tests \
   nuagepartnerprogram/cats:5.3.2 -X /home/tests
   ```
   - Example: 
  ```docker run -t -v ~/.ssh:/root/.ssh -v `pwd`/cats:/home/tests cats -X  /home/tests```

## Troubleshooting 

Every Lab configuration generates a report in `cats/reports` directory, you can view `output.xml` file to troubleshoot further.


## Feeback 

Please send your feedback to nuagex@nuagenetworks.net
