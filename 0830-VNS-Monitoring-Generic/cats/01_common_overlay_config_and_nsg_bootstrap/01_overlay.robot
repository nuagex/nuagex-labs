*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Create Organization Profile
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

Create Organization
    Create Organization
    ...    name=${org_name}
    ...    localAS=65000
    ...    cats_org_profile_name=${org_profile_name}

Create L3 domain template
    Create L3 Domain Template
    ...    name=${l3domain_template1_name}
    ...    cats_org_name=${org_name}

Create L3 domain
    Create L3 Domain
    ...    name=${customer_domain_name}
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_template_name=${l3domain_template1_name}
    ...    underlayEnabled=ENABLED  # to enable internet access for Test-PC with VIAVI windows agent installed
    ...    PATEnabled=ENABLED

Add DHCP server info for the customer domain
    Create DHCP Option in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    actualType=6
    ...    actualValues=@[1.1.1.1, 8.8.8.8]

Create Zones
    Create Zone
    ...    name=${hq_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}

    Create Zone
    ...    name=${branch1_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}

Create Subnets
    # HQ subnet
    Create Subnet
    ...    name=${hq_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_zone_name=${hq_zone_name}
    ...    cats_address=${hq_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_subnet_name=${hq_subnet_name}
    ...    minAddress=${hq_pc1_data_addr}
    ...    maxAddress=${hq_pc1_data_addr}

    # Branch1 subnet
    Create Subnet
    ...    name=${branch1_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_zone_name=${branch1_zone_name}
    ...    cats_address=${branch1_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_subnet_name=${branch1_subnet_name}
    ...    minAddress=${branch1_pc1_data_addr}
    ...    maxAddress=${branch1_pc1_data_addr}


Create default security policy
    Begin Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${customer_domain_name}

    Create Ingress Security Policy in L3 Domain
    ...    name=${sec_policy1_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    allowAddressSpoof=True
    ...    defaultAllowIP=True
    ...    defaultAllowNonIP=True

    Create Egress Security Policy in L3 Domain
    ...    name=${sec_policy1_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    defaultAllowIP=True

    Apply Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${customer_domain_name}