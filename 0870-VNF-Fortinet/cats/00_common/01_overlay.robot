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

    Enable DPI at L3 Domain Template
    ...    cats_org_name=${org_name}
    ...    cats_domain_template_name=${l3domain_template1_name}

Create L3 Customer domain
    Create L3 Domain
    ...    name=${customer_domain_name}
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_template_name=${l3domain_template1_name}
    ...    underlayEnabled=ENABLED
    ...    PATEnabled=ENABLED

Create L3 Managment domain
    Create L3 Domain
    ...    name=${managment_domain_name}
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_template_name=${l3domain_template1_name}
    ...    underlayEnabled=ENABLED
    ...    PATEnabled=ENABLED

Add DHCP server info for the customer domain
    Create DHCP Option in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    actualType=6
    ...    actualValues=@[1.1.1.1, 8.8.8.8]

Add DHCP server info for the managment domain
    Create DHCP Option in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${managment_domain_name}
    ...    actualType=6
    ...    actualValues=@[1.1.1.1, 8.8.8.8]

Create Zones
    Create Zone
    ...    name=${lan_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}

    Create Zone
    ...    name=${mgmt_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${managment_domain_name}

Create Subnets
    # LAN 1 Subnet
    Create Subnet
    ...    name=${lan1_subnet_name} 
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_zone_name=${lan_zone_name}
    ...    cats_address=${lan1_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_subnet_name=${lan1_subnet_name} 
    ...    minAddress=${lan1_pc1_data_addr}
    ...    maxAddress=${lan1_pc1_data_addr}

    # LAN 2 Subnet
    Create Subnet
    ...    name=${lan2_subnet_name} 
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_zone_name=${lan_zone_name}
    ...    cats_address=${lan2_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_subnet_name=${lan2_subnet_name} 
    ...    minAddress=${lan2_pc1_data_addr}
    ...    maxAddress=${lan2_pc1_data_addr}


    # Managment Lan Subnet
    Create Subnet
    ...    name=${mgmt_lan_subnet_name} 
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${managment_domain_name}
    ...    cats_zone_name=${mgmt_zone_name}
    ...    cats_address=${mgmt_lan_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${managment_domain_name}
    ...    cats_subnet_name=${mgmt_lan_subnet_name} 
    ...    minAddress=${mgmt_lan_pc1_data_addr}
    ...    maxAddress=${mgmt_lan_pc1_data_addr}

    # Managment Subnet
    Create Subnet
    ...    name=${vnf_mgmt_subnet_name} 
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${managment_domain_name}
    ...    cats_zone_name=${mgmt_zone_name}
    ...    cats_address=${vnf_mgmt_network_addr}

    
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

    Begin Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${managment_domain_name}

    Create Ingress Security Policy in L3 Domain
    ...    name=${sec_policy1_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${managment_domain_name}
    ...    allowAddressSpoof=True
    ...    defaultAllowIP=True
    ...    defaultAllowNonIP=True

    Create Egress Security Policy in L3 Domain
    ...    name=${sec_policy1_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${managment_domain_name}
    ...    defaultAllowIP=True

    Apply Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${managment_domain_name}