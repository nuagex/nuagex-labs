This lab demonstrates the NSG bootstrapping use cases using 1-factor-authentication method.

* Lab runs on [NuageX](https://nuagex.io)
* [`nuxctl`](https://nuxctl.nuagex.io) is used to deploy the lab
* [CATS](https://cats-docs.nuageteam.net) configures that use case once setup is ready

There are two flavors of configuration workflow, depending whether CATS is outside NuageX lab, or inside.

**CATS outside the lab**
In that case, the following files should be used:

* lab configuration file - [nuxctl_basic_vns_2nsgs.yml](./nuxctl_basic_vns_2nsgs.yml)
* CATS Test Suite files - [cats_outside_nuagex](./cats_setup/cats_outside_nuagex)

**CATS inside the lab**
In that case (which is extensively covered in [this article](http://cats-docs.nuageteam.net/test_suite_examples/0025_nux_nsg_1fabootstrap/)), the following files should be used:

* lab configuration file - [nuxctl_basic_vns_2nsgs_cats.yml](./nuxctl_basic_vns_2nsgs_cats.yml)
* CATS Test Suite files - [cats_inside_nuagex](./cats_setup/cats_inside_nuagex)


## How to deploy the lab
Leverage [nuxctl](https://nuxctl.nuagex.io) and deploy the lab in a single command:

```
nuxctl create-lab -l nuxctl_basic_vns_2nsgs.yml -c my_nuagex_credentials.yml
```

Write down the Public IP of the Lab and the `admin` user password for VSD.

## How to configure the use case
Use [CATS](https://cats-docs.nuageteam.net) framework and provided Test Suite. 

**For the case when CATS is outside NuageX**
1. Change the `${jumpbox_address}` value in the [`vars.robot`](cats_setup/vars.robot#L30) file to the Public IP of the lab you have deployed.
2. Change the admin password held in `line 40` of [`vars.robot`](cats_setup/vars.robot#L40) file to contain the password provided for your lab.

**For the case when CATS is inside NuageX**

Refer to [this article](http://cats-docs.nuageteam.net/test_suite_examples/0025_nux_nsg_1fabootstrap/).

## 3.2 Starting configuration process
The configuration process will handle all of the heavy-lifting of the lab configuration. Starting with overlay object creation as well as NSG bootstrapping and activation, finishing with the creation of the VNFs.

To launch the configuration sequence proceed with the following command issued on the labs jumpbox VM:

```bash
# issued on the jumpbox VM
# flags
## -X -- stop the execution on first error
## -v variable_name:variable_value -- set variable value
docker run -t \
  -v ${HOME}/.ssh:/root/.ssh \
  -v /home/admin/nuagex-labs/0010-VNS-BASIC-1/cats:/home/tests \
  nuagepartnerprogram/cats:5.3.2 \
    -v vsd_password:<VSD_PASSWORD> \
    -X /home/tests
```

Note, that in order to provide CATS container with passwordless access to the labs components the Jumpbox keys are shared with the container.  
Jumpbox's `${HOME}/.ssh` folder contents is exposed to the CATS container and mounted there by the `/root/.ssh` path. In effect, the `id_rsa` key on the Jumpbox will be available to the CATS container by the `/root/.ssh/id_rsa` path hence its configured on line [84](./cats/vars.robot#L84) of the variables file.


The configuration is successful if every step is marked with the green PASS status. The configuration execution log can be found under `cats/reports` directory (the full path is provided by CATS at the end of the execution output).