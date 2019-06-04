*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***

Get activation link for NSG1
    ${util_conn} =  Linux.Connect To Server
                    ...    server_address=localhost
                    ...    server_port=@{util_port_forwarding}[0]
                    ...    server_login=root
                    ...    server_password=Alcateldc

    NSG.Send NSG Activation
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${nsg1_name}

    Sleep    2

    ${activation_url1} =  NSG.Get Activation Link From na.log
                  ...    verbose=True

    Set Global Variable    ${activation_url1}

Get activation link for NSG2
    NSG.Send NSG Activation
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${nsg2_name}

    Sleep    2

    ${activation_url2} =  NSG.Get Activation Link From na.log
                  ...    verbose=True

    Set Global Variable    ${activation_url2}
