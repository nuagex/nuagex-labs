*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User
Force Tags        baseline-nsg-provisioning

*** Test Cases ***
Create NSG Template
    Create NSG Template
    ...    name=${nsg_template_name}
    ...    cats_infra_gw_profile_name=${infra_gw_profile_name}

Associate Infra Access Profile with Internet NSG Template
    Associate Infra Access Profile with NSG Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_infra_access_profile_name=${infra_access_profile_name}

Create Ports and VLANs in NSG Template
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

    # # port2 MPLS NETWORK
    # Create Port Template in NSG Template
    # ...    name=port2-MPLS
    # ...    physicalName=port2
    # ...    portType=NETWORK
    # ...    cats_nsg_template_name=${nsg_template_name}

    # Create VLAN Template in NSG Port Template
    # ...    value=0
    # ...    cats_nsg_template_name=${nsg_template_name}
    # ...    cats_nsg_port_template_name=port2-MPLS

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

    # Associate VSC Profile with NSG VLAN Template
    # ...    cats_nsg_template_name=${nsg_template_name}
    # ...    cats_nsg_port_template_name=port2-MPLS
    # ...    cats_vlan_id=0
    # ...    cats_vsc_profile_name=${vsc_profile2_name}

Create Uplink Connections
    Create Uplink Connection in NSG Vlan Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port1-Internet
    ...    cats_vlan_id=0
    ...    mode=Dynamic
    ...    role=PRIMARY
    ...    cats_underlay_name=Internet

    # Create Uplink Connection in NSG Vlan Template
    # ...    cats_nsg_template_name=${nsg_template_name}
    # ...    cats_nsg_port_template_name=port2-MPLS
    # ...    cats_vlan_id=0
    # ...    PATEnabled=False  # do not allow PAT to underlay through MPLS uplinks
    # ...    mode=Dynamic
    # ...    role=SECONDARY
    # ...    cats_underlay_name=MPLS

Create NSG Instances
    # hq
    Create NSG
    ...    name=${hq_nsg1_name}
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_org_name=${org_name}

    NSG.Update NSG Location
    ...  cats_org_name=${org_name}
    ...  cats_nsg_name=${hq_nsg1_name}
    ...  address=755 Ravendale Dr, Mountain View, CA, US

    # branch1
    Create NSG
    ...    name=${branch1_nsg1_name}
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_org_name=${org_name}

    NSG.Update NSG Location
    ...  cats_org_name=${org_name}
    ...  cats_nsg_name=${branch1_nsg1_name}
    ...  address=600 March Road, Ottawa, Canada


# Disable NAT-T on uplink
#     Disable NAT-T for NSG Network Port
#     ...    cats_nsg_name=${hq_nsg1_name}
#     ...    cats_nsg_port_name=port1-Internet
#     ...    cats_org_name=${org_name}

#     Disable NAT-T for NSG Network Port
#     ...    cats_nsg_name=${hq_nsg1_name}
#     ...    cats_nsg_port_name=port2-MPLS
#     ...    cats_org_name=${org_name}

#     Disable NAT-T for NSG Network Port
#     ...    cats_nsg_name=${branch1_nsg1_name}
#     ...    cats_nsg_port_name=port1-Internet
#     ...    cats_org_name=${org_name}

#     Disable NAT-T for NSG Network Port
#     ...    cats_nsg_name=${branch1_nsg1_name}
#     ...    cats_nsg_port_name=port2-MPLS
#     ...    cats_org_name=${org_name}


Create port4 for HQ NSG
    # port3 ACCESS
    Create Port in NSG
    ...  cats_org_name=${org_name}
    ...  cats_nsg_name=${hq_nsg1_name}
    ...  name=port4-Access
    ...  physicalName=port4
    ...  portType=ACCESS
    ...  VLANRange=0-4094

    Create VLAN in NSG Port
    ...  cats_org_name=${org_name}
    ...  cats_nsg_name=${hq_nsg1_name}
    ...  cats_nsg_port_name=port4-Access
    ...  value=0


Create vPorts and Bridge Interfaces for HQ-NSG
    Create Bridge vPort for NSG
    ...    name=${hq_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${hq_subnet2_name}
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_nsg_port_name=port3-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${hq_nsg1_vport1_name}
    ...    cats_vport_name=${hq_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

    #vport2 for installer branchpc
    Create Bridge vPort for NSG
    ...    name=${hq_nsg1_vport2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${hq_subnet_name}
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_nsg_port_name=port4-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${hq_nsg1_vport2_name}
    ...    cats_vport_name=${hq_nsg1_vport2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Create vPorts and Bridge Interfaces for Branch1-NSG
    Create Bridge vPort for NSG
    ...    name=${branch1_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${branch1_subnet_name}
    ...    cats_nsg_name=${branch1_nsg1_name}
    ...    cats_nsg_port_name=port3-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${branch1_nsg1_vport1_name}
    ...    cats_vport_name=${branch1_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}


Add installer user
    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_installer_username=cats

    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${branch1_nsg1_name}
    ...    cats_installer_username=cats
