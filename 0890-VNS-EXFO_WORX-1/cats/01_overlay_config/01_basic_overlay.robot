*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User
Force Tags        baseline-overlay-provisioning

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
    ...    encryptionManagementMode=MANAGED

Create Organization
    Create Organization
    ...    name=${org_name}
    ...    localAS=65000
    ...    flowCollectionEnabled=ENABLED
    ...    cats_org_profile_name=${org_profile_name}

Create L3 domain template
    Create L3 Domain Template
    ...    name=${l3domain_template1_name}
    ...    cats_org_name=${org_name}
    ...    encryption=DISABLED

    Enable DPI at L3 Domain Template
    ...    cats_org_name=${org_name}
    ...    cats_domain_template_name=${l3domain_template1_name}

Create L3 domain
    Create L3 Domain
    ...    name=${l3domain_name}
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_template_name=${l3domain_template1_name}
    ...    underlayEnabled=ENABLED
    ...    PATEnabled=ENABLED

Create DHCP Options in domain
    Create DHCP Option in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    actualType=6
    ...    actualValues=@[1.1.1.1]

Create Zones
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

Create Subnets
    # HQ subnet1
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
    # HQ subnet2
    Create Subnet
    ...    name=${hq_subnet2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${hq_zone_name}
    ...    cats_address=${hq_network2_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${hq_subnet2_name}
    ...    minAddress=${hq_igw1_data_addr}
    ...    maxAddress=${hq_igw1_data_addr}

    # branch1 subnet
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
    # branch1 subnet
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

    Create Egress Security Policy in L3 Domain
    ...    name=${sec_policy1_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    defaultAllowIP=True

    Apply Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${l3domain_name}