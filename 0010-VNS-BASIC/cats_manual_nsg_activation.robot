# this Test Suite provisions overlay and stops
# once everything is ready for manual NSG activation
# using the Branch PC VMs deployed in a lab

# the minimal changes required are
# External IP of the NuageX Lab (line 45)
# and admin password for VSD (line 47)

# author: Roman Dodin

*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Suite Setup       Login NuageX User

*** Variables ***
# basic overlay variables
${org_profile_name}            ORG_PROFILE
${l3domain_template1_name}     DOMAIN_TEMPLATE
${l3domain_name}               DOMAIN
${zone_name}                   ZONE
${subnet1_name}                SUBNET1
${subnet2_name}                SUBNET2
${subnet1_network_addr}        192.168.1.0/24
${subnet2_network_addr}        192.168.2.0/24
${sec_policy1_name}            ALLOW_ALL

# VNS variables
${infra_gw_profile_name}       IGW
${util1_fqdn}                  utility.nuage.lab
${vsc_profile1_name}           VSCPROF1
${vsc1_ip}                     10.0.0.3
${nsg_template_name}           NSG_TEMPLATE
${infra_access_profile_name}   IAP
${nsg1_name}                   NSG_1
${nsg2_name}                   NSG_2
${org_name}                    NUAGEX
${vport1_name}                 VPORT1
${vport2_name}                 VPORT2
${branch_pc1_data_addr}        192.168.1.101
${branch_pc2_data_addr}        192.168.2.102

*** Keywords ***
Login NuageX User
    NuageUserMgmt.Login User
    ...    cats_api_url=https://124.252.253.146:8443
    ...    cats_username=admin
    ...    cats_password=ROoNKLWXcjsM3MjE
    ...    cats_org_name=csp

*** Test Cases ***
Creating Organization Profile
    Create Organization Profile
    ...    name=${org_profile_name}
    ...    allowedForwardingClasses=@[A, B, C, D, E, F, G, H]
    ...    allowGatewayManagement=True
    ...    allowTrustedForwardingClass=True
    ...    BGPEnabled=True
    ...    DHCPLeaseInterval=24
    ...    enableApplicationPerformanceManagement=True
    ...    allowAdvancedQOSConfiguration=True
    ...    VNFManagementEnabled=True

Creating Organization
    Create Organization
    ...    name=${org_name}
    ...    localAS=65000
    ...    cats_org_profile_name=${org_profile_name}

Creating L3 domain template
    Create L3 Domain Template
    ...    name=${l3domain_template1_name}
    ...    cats_org_name=${org_name}

Creating L3 domain
    Create L3 Domain
    ...    name=${l3domain_name}
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_template_name=${l3domain_template1_name}

Creating a Zone
    Create Zone
    ...    name=${zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Creating Subnets
    Create Subnet
    ...    name=${subnet1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${zone_name}
    ...    cats_address=${subnet1_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${subnet1_name}
    ...    minAddress=${branch_pc1_data_addr}
    ...    maxAddress=${branch_pc1_data_addr}

    Create Subnet
    ...    name=${subnet2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${zone_name}
    ...    cats_address=${subnet2_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${subnet2_name}
    ...    minAddress=${branch_pc2_data_addr}
    ...    maxAddress=${branch_pc2_data_addr}

Create default security policy
    Begin Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${l3domain_name}

    Create Ingress Security Policy in L3 Domain
    ...    name=${sec_policy1_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    allowAddressSpoof=True
    ...    defaultAllowIP=True
    ...    defaultAllowNonIP=True

    Apply Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${l3domain_name}

#############################
#############################
#### VNS CONFIGURATION ######
#############################
#############################
Creating Infra GW Profile
    Create Infrastructure GW Profile
    ...    name=${infra_gw_profile_name}
    ...    proxyDNSName=${util1_fqdn}

Creating VSC Profile
    Create VSC Profile
    ...    name=${vsc_profile1_name}
    ...    firstController=${vsc1_ip}

Creating NSG Template
    Create NSG Template
    ...    name=${nsg_template_name}
    ...    cats_infra_gw_profile_name=${infra_gw_profile_name}

Creating Infrastructure Access Profile
    Create Infrastructure Access Profile
    ...    name=${infra_access_profile_name}
    ...    password=Alcateldc

Associating Infra Access Profile with NSG Template
    Associate Infra Access Profile with NSG Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_infra_access_profile_name=${infra_access_profile_name}

Creating Ports and VLANs in NSG Template
    # port1 NETWORK
    Create Port Template in NSG Template
    ...    name=port1
    ...    physicalName=port1
    ...    portType=NETWORK
    ...    cats_nsg_template_name=${nsg_template_name}

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port1

    # port2 DUMMY NETWORK
    Create Port Template in NSG Template
    ...    name=port2
    ...    physicalName=port2
    ...    portType=ACCESS
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    VLANRange=0-4094

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port2

    # port3 ACCESS
    Create Port Template in NSG Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    name=port3
    ...    physicalName=port3
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port3

Associating VSC Profile
    Associate VSC Profile with NSG VLAN Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port1
    ...    cats_vlan_id=0
    ...    cats_vsc_profile_name=${vsc_profile1_name}

Creating Uplink Connection
    Create Uplink Connection in NSG Vlan Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port1
    ...    cats_vlan_id=0
    ...    mode=Dynamic
    ...    role=PRIMARY

Creating NSG Instances
    Create NSG
    ...    name=${nsg1_name}
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_org_name=${org_name}

    Create NSG
    ...    name=${nsg2_name}
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_org_name=${org_name}

Creating vPorts and Bridge Interfaces for NSG1
    Create Bridge vPort for NSG
    ...    name=${vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${subnet1_name}
    ...    cats_nsg_name=${nsg1_name}
    ...    cats_nsg_port_name=port3
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=IFACE1
    ...    cats_vport_name=${vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Creating vPorts and Bridge Interfaces for NSG2
    Create Bridge vPort for NSG
    ...    name=${vport2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${subnet2_name}
    ...    cats_nsg_name=${nsg2_name}
    ...    cats_nsg_port_name=port3
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=IFACE2
    ...    cats_vport_name=${vport2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Adding installer user
    NuageVSD.Create User
    ...    userName=cats
    ...    password=cats
    ...    cats_org_name=${org_name}
    ...    email=vnsrussia@gmail.com


    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${nsg1_name}
    ...    cats_installer_username=cats

    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${nsg2_name}
    ...    cats_installer_username=cats