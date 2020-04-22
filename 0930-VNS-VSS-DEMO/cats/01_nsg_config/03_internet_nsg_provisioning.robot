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
    ...    name=port3-WiFi
    ...    physicalName=port3
    ...    portType=ACCESS
    ...    VLANRange=0-4094
    # port4 ACCESS WIFI
    Create Port Template in NSG Template
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    name=port4-Access
    ...    physicalName=port4
    ...    portType=ACCESS
    ...    VLANRange=0-4094

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port3-WiFi

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_nsg_port_template_name=port4-Access

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
    # HQ-SF
    Create NSG
    ...    name=${hq_sf_nsg1_name}
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_org_name=${org_name}
    # PA
    Create NSG
    ...    name=${pa_nsg1_name}
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_org_name=${org_name}
    # SJ
    Create NSG
    ...    name=${sj_nsg1_name}
    ...    cats_nsg_template_name=${nsg_template_name}
    ...    cats_org_name=${org_name}


Disable NAT-T on uplink
    Disable NAT-T for NSG Network Port
    ...    cats_nsg_name=${hq_sf_nsg1_name}
    ...    cats_nsg_port_name=port1-Internet
    ...    cats_org_name=${org_name}

    Disable NAT-T for NSG Network Port
    ...    cats_nsg_name=${pa_nsg1_name}
    ...    cats_nsg_port_name=port1-Internet
    ...    cats_org_name=${org_name}

    Disable NAT-T for NSG Network Port
    ...    cats_nsg_name=${sj_nsg1_name}
    ...    cats_nsg_port_name=port1-Internet
    ...    cats_org_name=${org_name}

Create vPorts and Bridge Interfaces for HQ-SF-NSG (CORP)    
    Create Bridge vPort for NSG
    ...    name=${hq_sf_nsg1_vport2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${corp_hq_sf_subnet_name}
    ...    cats_nsg_name=${hq_sf_nsg1_name}
    ...    cats_nsg_port_name=port4-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${hq_sf_nsg1_vport2_name}
    ...    cats_vport_name=${hq_sf_nsg1_vport2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Create vPorts and Bridge Interfaces for HQ-SF-NSG (GUEST)    
    Create Bridge vPort for NSG
    ...    name=${hq_sf_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${guest_hq_subnet_name}
    ...    cats_nsg_name=${hq_sf_nsg1_name}
    ...    cats_nsg_port_name=port3-WiFi
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${hq_sf_nsg1_vport1_name}
    ...    cats_vport_name=${hq_sf_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}

Create vPorts and Bridge Interfaces for PA-NSG (CORP)
    Create Bridge vPort for NSG
    ...    name=${pa_nsg1_vport2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${corp_pa_subnet_name}
    ...    cats_nsg_name=${pa_nsg1_name}
    ...    cats_nsg_port_name=port4-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${pa_nsg1_vport2_name}
    ...    cats_vport_name=${pa_nsg1_vport2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Create vPorts and Bridge Interfaces for PA-NSG (GUEST)
    Create Bridge vPort for NSG
    ...    name=${pa_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${guest_pa_subnet_name}
    ...    cats_nsg_name=${pa_nsg1_name}
    ...    cats_nsg_port_name=port3-WiFi
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${pa_nsg1_vport1_name}
    ...    cats_vport_name=${pa_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}

Create vPorts and Bridge Interfaces for SJ-NSG (CORP)
    # vport and interface for Branch-PC (also is an installer PC)
    Create Bridge vPort for NSG
    ...    name=${sj_nsg1_vport2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${corp_sj_subnet_name}
    ...    cats_nsg_name=${sj_nsg1_name}
    ...    cats_nsg_port_name=port4-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${sj_nsg1_vport2_name}
    ...    cats_vport_name=${sj_nsg1_vport2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Create vPorts and Bridge Interfaces for SJ-NSG (GUEST)
    # vport and interface for Branch-PC (also is an installer PC)
    Create Bridge vPort for NSG
    ...    name=${sj_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${guest_sj_subnet_name}
    ...    cats_nsg_name=${sj_nsg1_name}
    ...    cats_nsg_port_name=port3-WiFi
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=${sj_nsg1_vport1_name}
    ...    cats_vport_name=${sj_nsg1_vport1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${guest_l3domain_name}

Add installer user
    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${hq_sf_nsg1_name}
    ...    cats_installer_username=cats

    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${pa_nsg1_name}
    ...    cats_installer_username=cats
    
    Associate Installer with NSG
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${sj_nsg1_name}
    ...    cats_installer_username=cats
