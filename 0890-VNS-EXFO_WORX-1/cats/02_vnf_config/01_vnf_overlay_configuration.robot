*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Create VNF management domain
    Create L3 Domain
    ...    name=${vnf_mgmt_domain_name}
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_template_name=${l3domain_template1_name}
    ...    underlayEnabled=ENABLED
    ...    PATEnabled=ENABLED

Add DHCP server for the management domain
    Create DHCP Option in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}
    ...    actualType=6
    ...    actualValues=@[1.1.1.1, 8.8.8.8]

Create VNF Management domain objects
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


Configure Security Policies for VNF Management L3 Domain
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