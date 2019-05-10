*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Create installer user
    NuageVSD.Create User
    ...    userName=cats
    ...    password=cats
    ...    cats_org_name=${org_name}

Create Infra GW Profile
    Create Infrastructure GW Profile
    ...    name=${infra_gw_profile_name}
    ...    proxyDNSName=${util1_fqdn}

Create VSC Profiles
    Create VSC Profile
    ...    name=${vsc_profile1_name}
    ...    firstController=${vsc-internet_control_ip}

    Create VSC Profile
    ...    name=${vsc_profile2_name}
    ...    firstController=${vsc-mpls_control_ip}

Create Underlays
    Create Underlay in Platform Configuration
    ...    name=Internet

    Create Underlay in Platform Configuration
    ...    name=MPLS

Create Infrastructure Access Profile
    Create Infrastructure Access Profile
    ...    name=${infra_access_profile_name}
    ...    password=Alcateldc
