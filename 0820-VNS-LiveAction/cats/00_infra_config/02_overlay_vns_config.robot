*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Create Infra GW Profile
    Create Infrastructure GW Profile
    ...    name=${infra_gw_profile_name}
    ...    proxyDNSName=${util_fqdn}
    ...    upgradeAction=UPGRADE_AT_BOOTSTRAPPING
    ...    controllerLessDuration=P7DT0H0M
    ...    metadataUpgradePath=http://${util_fqdn}/metadata.json

Create VSC Profiles
    Create VSC Profile
    ...    name=${vsc_profile_name}
    ...    firstController=${vsc-mgmt_ip}

Create Infrastructure Access Profile
    Create Infrastructure Access Profile
    ...    name=${infra_access_profile_name}
    ...    password=Alcateldc

Create Underlays
    Create Underlay in Platform Configuration
    ...    name=Internet

Create Internet NSG-V Template
    Create NSG Template
    ...    name=${nsg_inet_template_name}
    ...    cats_infra_gw_profile_name=${infra_gw_profile_name}

Associate Infra Access Profile with Internet NSG Template
    Associate Infra Access Profile with NSG Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_infra_access_profile_name=${infra_access_profile_name}

Create Ports and VLANs in NSG-V Template
    # port1 INTERNET NETWORK
    Create Port Template in NSG Template
    ...    name=port1
    ...    physicalName=port1
    ...    portType=NETWORK
    ...    cats_nsg_template_name=${nsg_inet_template_name}

    Create VLAN Template in NSG Port Template
    ...    value=0
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port1

    # port2 ACCESS
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

    # port3 ACCESS
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

Associate VSC Profile
    Associate VSC Profile with NSG VLAN Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port1
    ...    cats_vlan_id=0
    ...    cats_vsc_profile_name=${vsc_profile_name}

Create Uplink Connections
    Create Uplink Connection in NSG Vlan Template
    ...    cats_nsg_template_name=${nsg_inet_template_name}
    ...    cats_nsg_port_template_name=port1
    ...    cats_vlan_id=0
    ...    mode=Dynamic
    ...    role=PRIMARY
    ...    cats_underlay_name=Internet