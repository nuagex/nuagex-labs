In this lab the physical appliance (IPE) is simulated by means of a virtual appliance (VIPE) specifically provisioned as if it is a physical device.

![pic1](https://www.lucidchart.com/publicSegments/view/1ffdc6bd-f72c-4e35-8664-293c44d67967/image.png)

To simulate an IPE we should have a hypervisor that would host the Ipanema VM (VIPE) and connect it to the lab infrastructure as we would do with a physical appliance. The Centos7.5 hypervisor is deployed by nuxctl and is defined in [this block](nuxctl_0801-vns-ipanema_wan_opt_mixed_mode.yml#L199-L214), it is a generic purpose image, therefore a user needs to configure it to support emulated IPE as explained below.

## Enable console access (optional)

In order to be able to connect to the hypervisors console, set the user password
```bash
# create password for the root user
sudo su
passwd
```

## Packages installation
To enable virtualization capabilities of the server install the following packages
```bash
# install packages
sudo yum install -y epel-release && \
sudo yum install -y libvirt @Virtualization @Virtualization Platform @Virtualization Tools libguestfs-tools bridge-utils vim && \
sudo chmod a+r /var/lib/libvirt/images/ && \

sudo systemctl enable libvirtd && \
sudo systemctl start libvirtd
```

## Network bridges configuration

The Ipanema IPE should be connected to the overlay created by Nuage Networks VNS to connect headquarters site to the rest of the Organization network. This is done by bridging VIPEs management, LAN and WAN interfaces to the hypervisors interfaces.

![pic2](https://www.lucidchart.com/publicSegments/view/10ad2c1d-141c-4e4e-be2b-f408948abbb3/image.png)

The following commands can be pasted in the hypervisors shell to configure the bridges:

```bash
# create MGMT/LAN/WAN bridges
# MGMT
brname=brMGMT

sudo tee -a /etc/sysconfig/network-scripts/ifcfg-$brname <<EOF
ONBOOT=yes
DEVICE=$brname
STP=no
MTU=9000
BOOTPROTO=none
TYPE=Bridge
EOF
sudo ifup $brname

# add eth1 interface to the brMGMT bridge 
sudo tee -a /etc/sysconfig/network-scripts/ifcfg-eth1 <<EOF
ONBOOT=yes
DEVICE=eth1
STP=no
MTU=9000
BOOTPROTO=static
BRIDGE=$brname
EOF

# LAN
brname=brLAN

sudo tee -a /etc/sysconfig/network-scripts/ifcfg-$brname <<EOF
ONBOOT=yes
DEVICE=$brname
STP=no
MTU=9000
BOOTPROTO=none
TYPE=Bridge
EOF
sudo ifup $brname

# add eth2 interface to the brLAN bridge
sudo tee -a /etc/sysconfig/network-scripts/ifcfg-eth2 <<EOF
ONBOOT=yes
DEVICE=eth2
STP=no
MTU=9000
BOOTPROTO=static
BRIDGE=$brname
EOF


# WAN
brname=brWAN

sudo tee -a /etc/sysconfig/network-scripts/ifcfg-$brname <<EOF
ONBOOT=yes
DEVICE=$brname
STP=no
MTU=9000
BOOTPROTO=none
TYPE=Bridge
EOF
sudo ifup $brname

# add eth3 interface to the brWAN bridge
sudo tee -a /etc/sysconfig/network-scripts/ifcfg-eth3 <<EOF
ONBOOT=yes
DEVICE=eth3
STP=no
MTU=9000
BOOTPROTO=static
BRIDGE=$brname
EOF

# apply changes
sudo systemctl restart network
```

## Download VIPE disk image
Download the VIPE disk image to the hypervisor

```
sudo mkdir -p /var/lib/libvirt/images/HQ-IPE1
sudo curl -o /var/lib/libvirt/images/HQ-IPE1/img.qcow2 http://some.url.net/img.qcow2
```

## Create WAN cache disk
Since our IPE should have WAN Optimization feature enabled we must provision it with the cache disk.

```bash
sudo qemu-img create -f qcow2 /var/lib/libvirt/images/HQ-IPE1/wan.img 30G
```

## Define and start VM
Using [this](https://github.com/nuagex/nuagex-labs/blob/master/0801-VNS-IPANEMA_WAN_OPT_MIXED_MODE/ipe_S_domain.xml) virsh domain file define IPE VM and start it.
```
sudo virsh define /var/lib/libvirt/images/HQ-IPE1/domain.xml && \
sudo virsh start HQ-IPE1
```

## Configure the IPE
Once the IPE VM is in running state, `virsh console` to it using the default Ipanema credentials `ipanema:ipanema` and configure the management address along with SALSA parameters.
Note, here you should use the IP address from the management subnet range as stated in the `vars.robot`.
```bash
# mgt address config
ipconfig lan none
ipconfig wan none
ipconfig mgt -a 10.100.99.99 -m 255.255.255.0
ipconfig -g 10.100.99.1
# salsa config
salsaconfig -url https://92.222.79.96:8443
salsaconfig -dom Nuage
reboot
```

### Verification steps
Once the VIPE is booted it is advised to verify its configuration.
```bash
# issued in the VIPE console
[ipe]$ ipconfig -d
Current configuration:
       [MGT]    IPaddr : 10.0.0.200
                IPmask : 255.255.255.0
                intfMTU: 1500
       Gateway         : none
       Hostname        : ipe
       Redirection mode: no

[ipe]$ salsaconfig -d
Current Configuration:
    Reversor server URL : https://92.222.79.96:8443
    Engine domain name  : Nuage
```
The management interface address and SALSA configuration should resemble the example above.