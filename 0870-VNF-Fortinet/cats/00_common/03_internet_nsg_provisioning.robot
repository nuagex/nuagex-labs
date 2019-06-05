*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Create Internet NSG Template
    Create NSG Template
    ...    name=${nsg_inet_template_name}
    ...    cats_infra_gw_profile_name=${infra_gw_profile_name}

Associate Infra Access Profile with Internet NSG Template
    Associate Infra Access Profile with NSG Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_infra_access_profile_name=${infra_access_profile_name}

Create Ports and VLANs in Internet NSG Template
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

    # port2 INTERNET NETWORK
    Create Port Template in NSG Template
    ...    name=port2-Internet
    ...    physicalName=port2
    ...    portType=NETWORK
    ...    cats_nsg_template_name=${nsg_inet_template_name}

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port2-Internet

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

    # port4 ACCESS
    Create Port Template in NSG Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    name=port4-Access
    ...    physicalName=port4
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port4-Access

    # port5 ACCESS
    Create Port Template in NSG Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    name=port5-Access
    ...    physicalName=port5
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port5-Access

    # port6 ACCESS
    Create Port Template in NSG Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    name=port6-Access
    ...    physicalName=port6
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port6-Access

    # slot1_port1 ACCESS
    Create Port Template in NSG Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    name=slot1_port1
    ...    physicalName=slot1_port1
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=slot1_port1

    # slot1_port2 ACCESS
    Create Port Template in NSG Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    name=slot1_port2
    ...    physicalName=slot1_port2
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=slot1_port2

    # slot1_port3 ACCESS
    Create Port Template in NSG Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    name=slot1_port3
    ...    physicalName=slot1_port3
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=slot1_port3

    # slot1_port4 ACCESS
    Create Port Template in NSG Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    name=slot1_port4
    ...    physicalName=slot1_port4
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=slot1_port4

Associate VSC Profile
    Associate VSC Profile with NSG VLAN Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port1-Internet
    ...    cats_vlan_id=0
    ...    cats_vsc_profile_name=${vsc_profile1_name}

    Associate VSC Profile with NSG VLAN Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port2-Internet
    ...    cats_vlan_id=0
    ...    cats_vsc_profile_name=${vsc_dummy_profile_name}

Create Uplink Connections
    Create Uplink Connection in NSG Vlan Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port1-Internet
    ...    cats_vlan_id=0
    ...    mode=Dynamic
    ...    role=PRIMARY
    ...    cats_underlay_name=Internet

Create NSG Instances
    # NSG-X01
    Create NSG
    ...    name=${hq_nsg1_name}
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_org_name=${org_name}


Disable NAT-T on uplink
    Disable NAT-T for NSG Network Port
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_nsg_port_name=port1-Internet
    ...    cats_org_name=${org_name}


Create vPorts and Bridge Interfaces for HQ
    Create Bridge vPort for NSG
    ...    name=${lan1_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${lan1_subnet_name}
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_nsg_port_name=slot1_port1
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${lan1_nsg1_vport1_name}
    ...    cats_vport_name=${lan1_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}

    Create Bridge vPort for NSG
    ...    name=${lan2_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${lan2_subnet_name}
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_nsg_port_name=slot1_port2
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${lan2_nsg1_vport1_name}
    ...    cats_vport_name=${lan2_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}

    Create Bridge vPort for NSG
    ...    name=${mgmt_lan_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${managment_domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${mgmt_lan_subnet_name}
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_nsg_port_name=slot1_port3
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${mgmt_lan_nsg1_vport1_name}
    ...    cats_vport_name=${mgmt_lan_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${managment_domain_name}

Add installer user
    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_installer_username=cats
    
