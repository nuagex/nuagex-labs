#!/bin/bash
# this file is meant to be run on a nuagex jumpbox vm
# it will pull the CATS container and clone the nuagex-lab repo
# to enable automatic configuration of a lab
cd ~
docker pull nuagepartnerprogram/cats:5.3.2
rm -rf ~/nuagex-labs
git clone https://github.com/nuagex/nuagex-labs
