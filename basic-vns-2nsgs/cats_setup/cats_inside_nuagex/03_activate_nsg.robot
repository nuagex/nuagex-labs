*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot
Suite Setup       Login csproot user

*** Test Cases ***

Get NSGs status
    ${nsg1} =    Get NSG
                ...    name=${nsg1_name}
                ...    cats_org_name=${org_name}

    ${nsg2} =    Get NSG
                ...    name=${nsg2_name}
                ...    cats_org_name=${org_name}



    Set Suite Variable    ${nsg1}
    Set Suite Variable    ${nsg2}

Setup SSH connections to Branch PCs and UtilVM
    ${brpc1_conn} =  Linux.Connect To Server
                     ...    server_address=${branch_pc1_mgmt_addr}
                     ...    server_login=centos
                     ...    server_password=Alcateldc

    Set Global Variable    ${brpc1_conn}

    ${brpc2_conn} =  Linux.Connect To Server
                     ...    server_address=${branch_pc2_mgmt_addr}
                     ...    server_login=centos
                     ...    server_password=Alcateldc

    Set Global Variable    ${brpc2_conn}

    ${util_conn} =  Linux.Connect To Server
                    ...    server_address=10.0.0.33
                    ...    server_login=root
                    ...    server_password=Alcateldc

    Set Global Variable    ${util_conn}

Activate NSG1
    Run Keyword If  "${nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate Bootstrap Procedure For NSG1

Activate NSG2
    Run Keyword If  "${nsg2.bootstrap_status}" != "ACTIVE"
    ...    Initiate Bootstrap Procedure For NSG2




*** Keywords ***
Initiate Bootstrap Procedure For NSG1
    Get activation link for NSG1

    SSHLibrary.Switch Connection    ${brpc1_conn}

    # make sure to update IP address
    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

    ${stdout}  ${rc} =  SSHLibrary.Execute Command
                        ...    ip netns exec ns-data python /opt/nsg_bootstrap/nsg_bootstrap.py ${activation_url1}
                        ...    sudo=True
                        ...    return_stdout=True
                        ...    return_rc=True
    Log    ${stdout}
    Should Be Equal   ${rc}    ${0}

Get activation link for NSG1
    SSHLibrary.Switch Connection    ${util_conn}

    NSG.Send NSG Activation
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${nsg1_name}

    Sleep    2

    ${activation_url1} =  NSG.Get Activation Link From na.log
                  ...    verbose=True

    Set Global Variable    ${activation_url1}

Initiate Bootstrap Procedure For NSG2
    Get activation link for NSG2

    SSHLibrary.Switch Connection    ${brpc2_conn}

    # make sure to update IP address
    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

    ${stdout}  ${rc} =  SSHLibrary.Execute Command
                        ...    ip netns exec ns-data python /opt/nsg_bootstrap/nsg_bootstrap.py ${activation_url2}
                        ...    sudo=True
                        ...    return_stdout=True
                        ...    return_rc=True
    Log    ${stdout}
    Should Be Equal   ${rc}    ${0}

Get activation link for NSG2
    SSHLibrary.Switch Connection    ${util_conn}

    NSG.Send NSG Activation
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${nsg2_name}

    Sleep    2

    ${activation_url2} =  NSG.Get Activation Link From na.log
                  ...    verbose=True

    Set Global Variable    ${activation_url2}