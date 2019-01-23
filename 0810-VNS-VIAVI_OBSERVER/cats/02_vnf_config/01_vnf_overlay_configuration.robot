*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Creating VNF management domain
    Create L3 Domain
    ...    name=${vnf_mgmt_domain_name}
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_template_name=${l3domain_template1_name}
    ...    underlayEnabled=ENABLED
    ...    PATEnabled=ENABLED

Adding DHCP server for the management domain
    Create DHCP Option in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}
    ...    actualType=6
    ...    actualValues=@[1.1.1.1, 8.8.8.8]

Creating VNF Management domain objects
    Create Zone
    ...    name=VNF_MGMT
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}

    Create Subnet
    ...    name=${vnf_mgmt_subnet1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}
    ...    cats_zone_name=VNF_MGMT
    ...    cats_address=${vnf_mgmt_subnet1_network_addr}

    Create Subnet
    ...    name=${vnf_mgmt_subnet4_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}
    ...    cats_zone_name=VNF_MGMT
    ...    cats_address=${vnf_mgmt_subnet4_network_addr}

    # EMS subnet
    Create Subnet
    ...    name=${vnf_mgmt_ems_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}
    ...    cats_zone_name=VNF_MGMT
    ...    cats_address=${vnf_mgmt_ems_subnet_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}
    ...    cats_subnet_name=${vnf_mgmt_ems_subnet_name}
    ...    minAddress=${ems_pc_data_addr}
    ...    maxAddress=${ems_pc_data_addr}

    # vport and interface for EMS PC
    Create Bridge vPort for NSG
    ...    name=EMS-PC-VPORT
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${vnf_mgmt_ems_subnet_name}
    ...    cats_nsg_name=${branch1_nsg1_name}
    ...    cats_nsg_port_name=port3-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=EMS-IFACE
    ...    cats_vport_name=EMS-PC-VPORT
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}

Configuring Security Policies for VNF Management L3 Domain
    Begin Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${vnf_mgmt_domain_name}

    Create Ingress Security Policy in L3 Domain
    ...    name=${sec_policy1_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}
    ...    allowAddressSpoof=True
    ...    defaultAllowIP=True
    ...    defaultAllowNonIP=True

    Create Egress Security Policy in L3 Domain
    ...    name=${sec_policy1_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}
    ...    defaultAllowIP=True
    ...    defaultAllowNonIP=True

    Apply Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${vnf_mgmt_domain_name}