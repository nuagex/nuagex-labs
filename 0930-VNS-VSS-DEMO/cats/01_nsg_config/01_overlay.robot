*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Create Organization Profile
    Create Organization Profile
    ...    name=${org_profile_name}
    ...    allowGatewayManagement=True
    ...    allowTrustedForwardingClass=True
    ...    BGPEnabled=True
    ...    DHCPLeaseInterval=24
    ...    enableApplicationPerformanceManagement=True
    ...    allowAdvancedQOSConfiguration=True
    ...    VNFManagementEnabled=True
    ...    webFilterEnabled=True

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
    
Create Corp L3 domain
    Create L3 Domain
    ...    name=${l3domain_name}
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_template_name=${l3domain_template_name}
    ...    underlayEnabled=ENABLED
    ...    PATEnabled=ENABLED

Create Guest L3 domain
    Create L3 Domain
    ...    name=${guest_l3domain_name}
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_template_name=${l3domain_template_name}
    ...    underlayEnabled=ENABLED
    ...    PATEnabled=ENABLED

Add DHCP server info for the customer domain
    Create DHCP Option in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}
    ...    actualType=6
    ...    actualValues=@[1.1.1.1, 8.8.8.8]

Create Zones
    Create Zone
    ...    name=${corp_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

    Create Zone
    ...    name=${public_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}

    Create Zone
    ...    name=${guest_wifi_zone_name} 
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}

Create Subnets
    # HQ-SF CORP subnet
    Create Subnet
    ...    name=${corp_hq_sf_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${corp_zone_name}
    ...    cats_address=${hq_sf_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${corp_hq_sf_subnet_name}
    ...    minAddress=${hq_sf_pc1_data_addr}
    ...    maxAddress=${hq_sf_pc1_data_addr}
    # PALO ALTO CORP subnet
    Create Subnet
    ...    name=${corp_pa_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${corp_zone_name}
    ...    cats_address=${pa_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${corp_pa_subnet_name}
    ...    minAddress=${pa_pc1_data_addr}
    ...    maxAddress=${pa_pc1_data_addr}

    # SAN JOSE CORP subnet
    Create Subnet
    ...    name=${corp_sj_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${corp_zone_name}
    ...    cats_address=${sj_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${corp_sj_subnet_name}
    ...    minAddress=${sj_pc1_data_addr}
    ...    maxAddress=${sj_pc1_data_addr}

    # HQ PUBLIC subnet
    Create Subnet
    ...    name=${guest_hq_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}
    ...    cats_zone_name=${public_zone_name} 
    ...    cats_address=${guest_hq_sf_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}
    ...    cats_subnet_name=${guest_hq_subnet_name}
    ...    minAddress=${hq_sf_server_data_addr} 
    ...    maxAddress=${hq_sf_server_data_addr} 

    # PALO ALTO GUEST subnet
    Create Subnet
    ...    name=${guest_pa_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}
    ...    cats_zone_name=${guest_wifi_zone_name} 
    ...    cats_address=${guest_pa_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}
    ...    cats_subnet_name=${guest_pa_subnet_name}
    ...    minAddress=${pa_tablet_data_addr}
    ...    maxAddress=${pa_tablet_data_addr}

    # SAN JOSE GUEST subnet
    Create Subnet
    ...    name=${guest_sj_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}
    ...    cats_zone_name=${guest_wifi_zone_name} 
    ...    cats_address=${guest_sj_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}
    ...    cats_subnet_name=${guest_sj_subnet_name}
    ...    minAddress=${sj_mobile_data_addr}
    ...    maxAddress=${sj_mobile_data_addr}

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
