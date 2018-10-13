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
