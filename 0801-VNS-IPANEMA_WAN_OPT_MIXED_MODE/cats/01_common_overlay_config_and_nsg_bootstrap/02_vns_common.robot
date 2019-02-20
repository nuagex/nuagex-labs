*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Creating installer user
    NuageVSD.Create User
    ...    userName=cats
    ...    password=cats
    ...    cats_org_name=${org_name}

Creating Infra GW Profile
    Create Infrastructure GW Profile
    ...    name=${infra_gw_profile_name}
    ...    proxyDNSName=${util1_fqdn}

Creating VSC Profiles
    Create VSC Profile
    ...    name=${vsc_profile1_name}
    ...    firstController=${vsc-i_ctrl_ip}


Creating Underlays
    Create Underlay in Platform Configuration
    ...    name=Internet

Creating Infrastructure Access Profile
    Create Infrastructure Access Profile
    ...    name=${infra_access_profile_name}
    ...    password=Alcateldc
