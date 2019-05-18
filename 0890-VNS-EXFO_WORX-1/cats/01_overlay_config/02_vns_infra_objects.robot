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


Ensure Flow Collection and Virtual Firewall rules are enabled in system config
    Set System Configuration
    ...  flowCollectionEnabled=True
    ...  virtualFirewallRulesEnabled=True


Configure ES Proxy address
    Process.Run Process
    ...  curl -s ifconfig.io
    ...  shell=True
    ...  alias=lab_ip

    ${lab_ip} =  Process.Get Process Result
                 ...  lab_ip
                 ...  stdout=True

    Set System Configuration
    ...  statsDatabaseProxy=${lab_ip}:6200


Create Infra GW Profile
    Create Infrastructure GW Profile
    ...    name=${infra_gw_profile_name}
    ...    proxyDNSName=${util1_fqdn}


Create VSC Profiles
    Create VSC Profile
    ...    name=${vsc_profile1_name}
    ...    firstController=${vsc-internet_mgmt_ip}

Create Underlays
    Create Underlay in Platform Configuration
    ...    name=Internet

Create Infrastructure Access Profile
    Create Infrastructure Access Profile
    ...    name=${infra_access_profile_name}
    ...    password=Alcateldc


*** Keywords ***
Set System Configuration
    [Arguments]
    ...  &{kwargs}

    @{cfg} =  Get VSD Object
              ...  cats_obj_type=SYSTEM CONFIGURATION
              ...  cats_parent_obj=CURRENT_USER
              ...  cats_get_object_list=True

    ${obj} =  Update VSD Object
              ...  cats_obj_type=SYSTEM CONFIGURATION
              ...  cats_obj=@{cfg}[0]
              ...  &{kwargs}

    [Return]    ${obj}

