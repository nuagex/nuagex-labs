*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***

Get activation link for NSG3
    ${util_conn} =  Linux.Connect To Server
                    ...    server_address=localhost
                    ...    server_port=@{util_port_forwarding}[0]
                    ...    server_login=root
                    ...    server_password=Alcateldc

    NSG.Send NSG Activation
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${nsg3_name}

    Sleep    2

    ${activation_url3} =  NSG.Get Activation Link From na.log
                  ...    verbose=True

    Set Global Variable    ${activation_url3}

Get activation link for NSG4
    NSG.Send NSG Activation
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${nsg4_name}

    Sleep    2

    ${activation_url4} =  NSG.Get Activation Link From na.log
                  ...    verbose=True

    Set Global Variable    ${activation_url4}

Get activation link for NSG5
    NSG.Send NSG Activation
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${nsg5_name}

    Sleep    2

    ${activation_url5} =  NSG.Get Activation Link From na.log
                  ...    verbose=True

    Set Global Variable    ${activation_url5}
