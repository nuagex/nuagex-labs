*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Create NSG Instances
    # Sacramento
    Create NSG
    ...    name=${sac_nsg_name}
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_org_name=${org_name}
    # Edison
    Create NSG
    ...    name=${edison_nsg_name}
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_org_name=${org_name}

Add installer user
    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${sac_nsg_name}
    ...    cats_installer_username=${nsg_user}
    
    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${edison_nsg_name}
    ...    cats_installer_username=${nsg_user}

Create vPorts and Bridge Interfaces for Sacramento NSG
    Create Bridge vPort for NSG
    ...    name=${sac_nsg_vport_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${sac_subnet_name}
    ...    cats_nsg_name=${sac_nsg_name}
    ...    cats_nsg_port_name=port3-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${sac_nsg_vport_name}
    ...    cats_vport_name=${sac_nsg_vport_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}

    # vport and interface for Test-PC
    Create Bridge vPort for NSG
    ...    name=${edison_nsg_vport_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${edison_subnet_name}
    ...    cats_nsg_name=${edison_nsg_name}
    ...    cats_nsg_port_name=port3-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${edison_nsg_vport_name}
    ...    cats_vport_name=${edison_nsg_vport_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}

Disable NAT-T on uplink
    Disable NAT-T for NSG Network Port
    ...    cats_nsg_name=${sac_nsg_name}
    ...    cats_nsg_port_name=port1
    ...    cats_org_name=${org_name}

    Disable NAT-T for NSG Network Port
    ...    cats_nsg_name=${edison_nsg_name}
    ...    cats_nsg_port_name=port1
    ...    cats_org_name=${org_name}

