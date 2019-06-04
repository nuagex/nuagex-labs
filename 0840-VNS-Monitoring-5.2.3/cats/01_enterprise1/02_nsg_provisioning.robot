*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Creating Infra GW Profile
    Create Infrastructure GW Profile
    ...    name=${infra_gw_profile_name}
    ...    proxyDNSName=${util1_fqdn}

Creating VSC Profile Internet
    Create VSC Profile
    ...    name=${vsc_profile1_name}
    ...    firstController=${vsc1_ip}

Creating VSC Profile MPLS
    Create VSC Profile
    ...    name=${vsc_profile2_name}
    ...    firstController=${vsc2_ip}

Creating NSG Template
    Create NSG Template
    ...    name=${nsg_template_name}
    ...    cats_infra_gw_profile_name=${infra_gw_profile_name}

Creating Infrastructure Access Profile
    Create Infrastructure Access Profile
    ...    name=${infra_access_profile_name}
    ...    password=Alcateldc

Associating Infra Access Profile with NSG Template
    Associate Infra Access Profile with NSG Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_infra_access_profile_name=${infra_access_profile_name}

Creating Ports and VLANs in NSG Template
    # port1 INTERNET NETWORK
    Create Port Template in NSG Template
    ...    name=port1
    ...    physicalName=port1
    ...    portType=NETWORK
    ...    cats_nsg_template_name=${nsg_template_name}

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port1

    # port2 MPLS NETWORK
    Create Port Template in NSG Template
    ...    name=port2
    ...    physicalName=port2
    ...    portType=NETWORK
    ...    cats_nsg_template_name=${nsg_template_name}

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port2

    # port3 ACCESS
    Create Port Template in NSG Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    name=port3
    ...    physicalName=port3
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port3

Associating VSC Profile Internet
    Associate VSC Profile with NSG VLAN Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port1
    ...    cats_vlan_id=0
    ...    cats_vsc_profile_name=${vsc_profile1_name}

Creating Uplink Connection Internet
    Create Uplink Connection in NSG Vlan Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port1
    ...    cats_vlan_id=0
    ...    mode=Dynamic
    ...    role=PRIMARY
    ...    cats_underlay_name=Internet

Associating VSC Profile MPLS
    Associate VSC Profile with NSG VLAN Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port2
    ...    cats_vlan_id=0
    ...    cats_vsc_profile_name=${vsc_profile2_name}

Creating Uplink Connection MPLS
    Create Uplink Connection in NSG Vlan Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port2
    ...    cats_vlan_id=0
    ...    mode=Dynamic
    ...    role=SECONDARY
    ...    cats_underlay_name=MPLS

Creating NSG Instances
    Create NSG
    ...    name=${nsg1_name}
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_org_name=${org_name}

    Create NSG
    ...    name=${nsg2_name}
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_org_name=${org_name}

Disabling NAT-T on uplinks
    # BRANCH1 NSG
    NSG.Update Port In NSG
    ...    name=port1
    ...    cats_nsg_name=${nsg1_name}
    ...    cats_org_name=${org_name}
    ...    enableNATProbes=False

    NSG.Update Port In NSG
    ...    name=port2
    ...    cats_nsg_name=${nsg1_name}
    ...    cats_org_name=${org_name}
    ...    enableNATProbes=False

    # BRANCH2 NSG
    NSG.Update Port In NSG
    ...    name=port1
    ...    cats_nsg_name=${nsg2_name}
    ...    cats_org_name=${org_name}
    ...    enableNATProbes=False

    NSG.Update Port In NSG
    ...    name=port2
    ...    cats_nsg_name=${nsg2_name}
    ...    cats_org_name=${org_name}
    ...    enableNATProbes=False

Creating vPorts and Bridge Interfaces for NSG1
    Create Bridge vPort for NSG
    ...    name=${vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${subnet1_name}
    ...    cats_nsg_name=${nsg1_name}
    ...    cats_nsg_port_name=port3
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=IFACE1
    ...    cats_vport_name=${vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Creating vPorts and Bridge Interfaces for NSG2
    Create Bridge vPort for NSG
    ...    name=${vport2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${subnet2_name}
    ...    cats_nsg_name=${nsg2_name}
    ...    cats_nsg_port_name=port3
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=IFACE2
    ...    cats_vport_name=${vport2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Adding installer user
    NuageVSD.Create User
    ...    userName=cats
    ...    password=cats
    ...    cats_org_name=${org_name}

    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${nsg1_name}
    ...    cats_installer_username=cats

    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${nsg2_name}
    ...    cats_installer_username=cats
