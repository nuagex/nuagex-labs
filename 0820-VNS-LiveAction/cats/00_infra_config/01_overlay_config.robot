*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Create Organization
    Create Organization
    ...    name=${org_name}
    ...    localAS=65000
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
    ...    name=${customer_domain_name}
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_template_name=${l3domain_template_name}
    ...    underlayEnabled=ENABLED  # to enable internet access for Test-PC with VIAVI windows agent installed
    ...    PATEnabled=ENABLED

Create Zones
    # Sacramento Zone
    Create Zone
    ...    name=${sac_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}

    # Edison Zone
    Create Zone
    ...    name=${edison_zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}

Create Subnets
    # Sacramento subnet
    Create Subnet
    ...    name=${sac_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_zone_name=${sac_zone_name}
    ...    cats_address=${sac_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_subnet_name=${sac_subnet_name}
    ...    minAddress=${sac_subnet_min_address}
    ...    maxAddress=${sac_subnet_max_address}

    # Edison subnet
    Create Subnet
    ...    name=${edison_subnet_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_zone_name=${edison_zone_name}
    ...    cats_address=${edison_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_subnet_name=${edison_subnet_name}
    ...    minAddress=${edison_subnet_min_address}
    ...    maxAddress=${edison_subnet_max_address}

Create default security policy
    Begin Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${customer_domain_name}

    # Allow all ingress
    Create Ingress Security Policy in L3 Domain
    ...    name=${sec_policy_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    allowAddressSpoof=True
    ...    defaultAllowIP=True
    ...    defaultAllowNonIP=True

    # Allow all egress
    Create Egress Security Policy in L3 Domain
    ...    name=${sec_policy_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    defaultAllowIP=True

    Apply Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${customer_domain_name}


CSPROOT can create user in Platform
    # NSG-V Email Factor Authentication User
    NuageVSD.Create User
    ...    cats_org_name=${org_name}
    ...    userName=${nsg_user}
    ...    password=${nsg_user_pswd}
    ...    firstName=${nsg_username}
    ...    lastName=${nsg_username}
    ...    email=${nsg_user_email}

    # Proxy CSP Root User
    NuageVSD.Create User
    ...    cats_org_name=${csp_org_name}
    ...    userName=${proxy_user}
    ...    password=${proxy_user}
    ...    firstName=${proxy_user}
    ...    lastName=${proxy_user}
    ...    email=${proxy_user}@csp.com

CSPROOT can GET user in Platform
    Get User in Platform
    ...    userName=${proxy_user}

CSPROOT can ADD user in Root Group in Platform
    Add user to group
    ...    cats_username=${proxy_user}
    ...    cats_org_name=csp
    ...    cats_group_name=Root Group
