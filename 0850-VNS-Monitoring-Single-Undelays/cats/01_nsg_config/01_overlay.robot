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
    ...    flowCollectionEnabled=ENABLED
    ...    cats_org_profile_name=${org_profile_name}

Create L3 domain template
    Create L3 Domain Template
    ...    name=${l3domain_template_name}
    ...    cats_org_name=${org_name}

    Enable DPI at L3 Domain Template
    ...    cats_org_name=${org_name}
    ...    cats_domain_template_name=${l3domain_template_name}
    
Create L3 domain
    Create L3 Domain
    ...    name=${l3domain_name}
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_template_name=${l3domain_template_name}
    ...    underlayEnabled=ENABLED
    ...    PATEnabled=ENABLED

Add DHCP server info for the customer domain
    Create DHCP Option in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    actualType=6
    ...    actualValues=@[1.1.1.1, 8.8.8.8]

Create Zones
    Create Zone
    ...    name=${hq_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

    Create Zone
    ...    name=${mv_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

    Create Zone
    ...    name=${ny_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Create Subnets
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
    # mv subnet
    Create Subnet
    ...    name=${mv_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${mv_zone_name}
    ...    cats_address=${mv_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${mv_subnet_name}
    ...    minAddress=${mv_pc1_data_addr}
    ...    maxAddress=${mv_pc1_data_addr}

    # ny subnet
    Create Subnet
    ...    name=${ny_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${ny_zone_name}
    ...    cats_address=${ny_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${ny_subnet_name}
    ...    minAddress=${ny_pc1_data_addr}
    ...    maxAddress=${ny_pc1_data_addr}


Create default security policy
    Begin Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${l3domain_name}

    Create Ingress Security Policy in L3 Domain
    ...    name=${sec_policy_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    allowAddressSpoof=True
    ...    defaultAllowIP=True
    ...    defaultAllowNonIP=True

    Create Egress Security Policy in L3 Domain
    ...    name=${sec_policy_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    defaultAllowIP=True

    Apply Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${l3domain_name}

Set elasticSearch proxy as lab public ip
    Set System Configuration
    ...  statsDatabaseProxy=${lab_ip_address}:6200

*** Keywords ***
Set System Configuration
    [Arguments]
    ...  &{kwargs}

    @{cfg} =  Get VSD Object
              ...  cats_obj_type=SYSTEM CONFIGURATION
              ...  cats_parent_obj=CURRENT_USER
              ...  cats_get_object_list=True

    ${obj} =  Update VSD Object
              ...  cats_obj_type=SYSTEM CONFIGURATION
              ...  cats_obj=@{cfg}[0]
              ...  &{kwargs}

    [Return]    ${obj}
