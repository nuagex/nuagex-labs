*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

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

Creating Zones
    Create Zone
    ...    name=${hq_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

    Create Zone
    ...    name=${branch1_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

    Create Zone
    ...    name=${branch2_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}


    Create Zone
    ...    name=${branch3_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Creating Subnets
    # HQ subnet
    Create Subnet
    ...    name=${hq_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${hq_zone_name}
    ...    cats_address=${hq_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${hq_subnet_name}
    ...    minAddress=${hq_pc1_data_addr}
    ...    maxAddress=${hq_pc1_data_addr}

    # Branch1 subnet
    Create Subnet
    ...    name=${branch1_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${branch1_zone_name}
    ...    cats_address=${branch1_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${branch1_subnet_name}
    ...    minAddress=${branch1_pc1_data_addr}
    ...    maxAddress=${branch1_pc1_data_addr}

    # Branch2 subnet
    Create Subnet
    ...    name=${branch2_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${branch2_zone_name}
    ...    cats_address=${branch2_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${branch2_subnet_name}
    ...    minAddress=${branch2_pc1_data_addr}
    ...    maxAddress=${branch2_pc1_data_addr}

    # Branch3 subnet
    Create Subnet
    ...    name=${branch3_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${branch3_zone_name}
    ...    cats_address=${branch3_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${branch3_subnet_name}
    ...    minAddress=${branch3_pc1_data_addr}
    ...    maxAddress=${branch3_pc1_data_addr}

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