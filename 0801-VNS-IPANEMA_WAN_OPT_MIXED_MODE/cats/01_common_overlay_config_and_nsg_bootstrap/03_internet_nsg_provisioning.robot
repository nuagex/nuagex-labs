*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Creating Internet NSG Template
    Create NSG Template
    ...    name=${nsg_inet_template_name}
    ...    cats_infra_gw_profile_name=${infra_gw_profile_name}

Associating Infra Access Profile with Internet NSG Template
    Associate Infra Access Profile with NSG Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_infra_access_profile_name=${infra_access_profile_name}

Creating Ports and VLANs in Internet NSG Template
    # port1 INTERNET NETWORK
    Create Port Template in NSG Template
    ...    name=port1-Internet
    ...    physicalName=port1
    ...    portType=NETWORK
    ...    cats_nsg_template_name=${nsg_inet_template_name}

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port1-Internet

    # port3 ACCESS
    Create Port Template in NSG Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    name=port3-Access
    ...    physicalName=port3
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port3-Access

Associating VSC Profile
    Associate VSC Profile with NSG VLAN Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port1-Internet
    ...    cats_vlan_id=0
    ...    cats_vsc_profile_name=${vsc_profile1_name}

Creating Uplink Connections
    Create Uplink Connection in NSG Vlan Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port1-Internet
    ...    cats_vlan_id=0
    ...    mode=Dynamic
    ...    role=PRIMARY
    ...    cats_underlay_name=Internet

Creating NSG Instances
    # hq
    Create NSG
    ...    name=${hq_nsg1_name}
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_org_name=${org_name}

    Create NSG
    ...    name=${branch1_nsg1_name}
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_org_name=${org_name}

    Create NSG
    ...    name=${branch2_nsg1_name}
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_org_name=${org_name}

    Create NSG
    ...    name=${branch3_nsg1_name}
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_org_name=${org_name}


Creating Port and VLAN for Installer PC on Branch1-NSG
    # port4 ACCESS
    NSG.Create Port in NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${branch1_nsg1_name}
    ...    name=port4-Access
    ...    physicalName=port4
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    NSG.Create VLAN in NSG Port
    ...    cats_org_name=${org_name}
    ...    value=0
    ...    cats_nsg_name=${branch1_nsg1_name}
    ...    cats_nsg_port_name=port4-Access

Creating Ports and VLANs for IPE connected to HQ-NSG1
    # port4 ACCESS
    NSG.Create Port in NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    name=port4-Access
    ...    physicalName=port4
    ...    description=connection for IPE mgmt interface
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    NSG.Create VLAN in NSG Port
    ...    cats_org_name=${org_name}
    ...    value=0
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_nsg_port_name=port4-Access

    # port5 ACCESS
    NSG.Create Port in NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    name=port5-Access
    ...    physicalName=port5
    ...    description=Installer PC connection
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    NSG.Create VLAN in NSG Port
    ...    cats_org_name=${org_name}
    ...    value=0
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_nsg_port_name=port5-Access

Disabling NAT-T on uplink
    Disable NAT-T for NSG Network Port
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_nsg_port_name=port1-Internet
    ...    cats_org_name=${org_name}

    Disable NAT-T for NSG Network Port
    ...    cats_nsg_name=${branch1_nsg1_name}
    ...    cats_nsg_port_name=port1-Internet
    ...    cats_org_name=${org_name}

    Disable NAT-T for NSG Network Port
    ...    cats_nsg_name=${branch2_nsg1_name}
    ...    cats_nsg_port_name=port1-Internet
    ...    cats_org_name=${org_name}

    Disable NAT-T for NSG Network Port
    ...    cats_nsg_name=${branch3_nsg1_name}
    ...    cats_nsg_port_name=port1-Internet
    ...    cats_org_name=${org_name}

Creating vPorts and Bridge Interfaces for HQ-NSG1
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

Creating vPorts and Bridge Interfaces for BRANCH1-NSG1
    Create Bridge vPort for NSG
    ...    name=${branch1_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${branch1_subnet_name}
    ...    cats_nsg_name=${branch1_nsg1_name}
    ...    cats_nsg_port_name=port4-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${branch1_nsg1_vport1_name}
    ...    cats_vport_name=${branch1_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}


Creating vPorts and Bridge Interfaces for BRANCH2-NSG1
    Create Bridge vPort for NSG
    ...    name=${branch2_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${branch2_subnet_name}
    ...    cats_nsg_name=${branch2_nsg1_name}
    ...    cats_nsg_port_name=port3-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${branch2_nsg1_vport1_name}
    ...    cats_vport_name=${branch2_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Creating vPorts and Bridge Interfaces for BRANCH3-NSG1
    Create Bridge vPort for NSG
    ...    name=${branch3_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${branch3_subnet_name}
    ...    cats_nsg_name=${branch3_nsg1_name}
    ...    cats_nsg_port_name=port3-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${branch3_nsg1_vport1_name}
    ...    cats_vport_name=${branch3_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Adding installer user
    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_installer_username=cats
    
    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${branch1_nsg1_name}
    ...    cats_installer_username=cats

    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${branch2_nsg1_name}
    ...    cats_installer_username=cats

    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${branch3_nsg1_name}
    ...    cats_installer_username=cats
