# 0810-VNS-VIAVI

* **version:** 1.0.0
* **tags:** VIAVI
* **requirements**: Nuage 5.2.3+
* **designer**: Roman Dodin

This Lab demonstrates joint integration between Nuage Networks VNS and [VIAVI Observer Live](https://www.viavisolutions.com/en-us/products/observerlive) solution. It consists of a single underlay and an Organization with a HQ and a branch site. Both HQ and a Branch are equipped with an NSG, which in turn runs VIAVI Virtual Agent as a Hosted VNF.

The automation harness provided with this lab enables a user to demonstrate the following use cases of a joint integration:

* VIAVI VNF deployment and Osberver Live service discovery.
* Network test between the sites - proactive, ongoing network link testing performed by VIAVI VNF agents.
* Service validation - establishing visibility between the cloud and on-premises VNF agents.
* Remote user troubleshooting - leveraging Windows machine connected with Nuage Networks VNS and running VIAVI agent.


Once automatically deployed and configured the lab will conform to the following diagram:
![lab](https://gitlab.com/rdodin/pics/wikis/uploads/273beee2677f3d19950abe8ddec4753b/image.png)

The Headquarters site and the branch office are emulated using the [Branch-PC image](https://nuagenetworks.zendesk.com/hc/en-us/articles/360010244033) which allows us to generate and analyze traffic as well as run some real-world applications.

# Deployment
The deployment process is powered by [nuxctl](htpps://nuxctl.nuagex.io) CLI tool. All the infrastructure deployment will be completed once a user runs the lab template available in this repo.

The lab template is based on the **Nuage Networks 5.3.2 - VNS SD-WAN Portal 3.2.1** template and has additional infra components defined to support the integration and use cases demonstration.

```bash
# make sure to fill in your nuagex public key information in the lab template
# before running the command
nuxctl create-lab -l nuxctl_0810-vns-viavi_observer.yml --wait
```

# Configuration
When lab deployment is finished, proceed with automatic lab configuration. Lab configuration is saved in a set of [CATS](http://cats-docs.nuageteam.net) scripts contained in a [cats](./cats/) folder of this repo.

## Variables file
The configuration variables are stored in a single [vars.robot](./cats/vars.robot) file and you need to fill in the values there on the lines marked with `TO_BE_FILLED_BY_A_USER` string. These variables are user-specific, therefore you need to fill them in before running the configuration scripts.

## Starting configuration process
The configuration process will handle all the heavy-lifting of the lab configuration. Starting with overlay objects creation, going through NSG bootstrap and activation, finishing with VNFs creation and insertion policies configuration.

To launch the configuration sequence a user need to download CATS to their machine or use CATS in a container.

The following example start the whole configuration process using CATS docker container on a users machine:

```bash
# being in the lab directory (where this README.md file is located)
# flags:
## -X -- stop the execution if error occurs

docker run -t \
  -v ${HOME}/.ssh:/root/.ssh \
  -v `pwd`/cats:/home/tests \
  cats -X /home/tests
```

The execution log can be found under `cats/reports` directory.

# Use cases

Use cases execution and provisioning are to be carried out by a user manually after the lab configuration finishes. Check with the VIAVI Integration Guide for use cases configuration instructions.