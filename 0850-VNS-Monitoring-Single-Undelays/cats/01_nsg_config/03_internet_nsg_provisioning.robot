*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Create Internet NSG Template
    Create NSG Template
    ...    name=${nsg_template_name}
    ...    cats_infra_gw_profile_name=${infra_gw_profile_name}

Associate Infra Access Profile with Internet NSG Template
    Associate Infra Access Profile with NSG Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_infra_access_profile_name=${infra_access_profile_name}

Create Ports and VLANs in Internet NSG Template
    # port1 INTERNET NETWORK
    Create Port Template in NSG Template
    ...    name=port1-Internet
    ...    physicalName=port1
    ...    portType=NETWORK
    ...    cats_nsg_template_name=${nsg_template_name}

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port1-Internet

    # port3 ACCESS
    Create Port Template in NSG Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    name=port3-Access
    ...    physicalName=port3
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port3-Access

Associate VSC Profile
    Associate VSC Profile with NSG VLAN Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port1-Internet
    ...    cats_vlan_id=0
    ...    cats_vsc_profile_name=${vsc_profile1_name}

Create Uplink Connections
    Create Uplink Connection in NSG Vlan Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port1-Internet
    ...    cats_vlan_id=0
    ...    mode=Dynamic
    ...    role=PRIMARY
    ...    cats_underlay_name=Internet


Create NSG Instances
    # hq
    Create NSG
    ...    name=${hq_nsg1_name}
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_org_name=${org_name}
    # mv
    Create NSG
    ...    name=${mv_nsg1_name}
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_org_name=${org_name}
    # ny
    Create NSG
    ...    name=${ny_nsg1_name}
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_org_name=${org_name}


Disable NAT-T on uplink
    Disable NAT-T for NSG Network Port
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_nsg_port_name=port1-Internet
    ...    cats_org_name=${org_name}

    Disable NAT-T for NSG Network Port
    ...    cats_nsg_name=${mv_nsg1_name}
    ...    cats_nsg_port_name=port1-Internet
    ...    cats_org_name=${org_name}

    Disable NAT-T for NSG Network Port
    ...    cats_nsg_name=${ny_nsg1_name}
    ...    cats_nsg_port_name=port1-Internet
    ...    cats_org_name=${org_name}

Create vPorts and Bridge Interfaces for HQ-NSG
    Create Bridge vPort for NSG
    ...    name=${hq_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${hq_subnet_name}
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_nsg_port_name=port3-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${hq_nsg1_vport1_name}
    ...    cats_vport_name=${hq_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Create vPorts and Bridge Interfaces for MV-NSG
    Create Bridge vPort for NSG
    ...    name=${mv_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${mv_subnet_name}
    ...    cats_nsg_name=${mv_nsg1_name}
    ...    cats_nsg_port_name=port3-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${mv_nsg1_vport1_name}
    ...    cats_vport_name=${mv_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Create vPorts and Bridge Interfaces for NY-NSG
    # vport and interface for Branch-PC (also is an installer PC)
    Create Bridge vPort for NSG
    ...    name=${ny_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${ny_subnet_name}
    ...    cats_nsg_name=${ny_nsg1_name}
    ...    cats_nsg_port_name=port3-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${ny_nsg1_vport1_name}
    ...    cats_vport_name=${ny_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Add installer user
    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_installer_username=cats

    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${mv_nsg1_name}
    ...    cats_installer_username=cats
    
    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${ny_nsg1_name}
    ...    cats_installer_username=cats
