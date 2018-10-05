*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot

*** Test Cases ***
Setup SSH connections to Branch PCs
    ${brpc1_conn} =  Linux.Connect To Server
                     ...    server_address=localhost
                     ...    server_port=@{brpc1_port_forwarding}[0]
                     ...    server_login=centos
                     ...    server_password=Alcateldc

    Set Global Variable    ${brpc1_conn}

    ${brpc2_conn} =  Linux.Connect To Server
                     ...    server_address=localhost
                     ...    server_port=@{brpc2_port_forwarding}[0]
                     ...    server_login=centos
                     ...    server_password=Alcateldc

    Set Global Variable    ${brpc2_conn}

Activate NSG1
    ${nsg} =    Get NSG
                ...    name=${nsg1_name}
                ...    cats_org_name=${org_name}

    Run Keyword If  "${nsg.bootstrap_status}" != "ACTIVE"
    ...    Initiate Bootstrap Procedure For NSG1

Activate NSG2
    ${nsg} =    Get NSG
                ...    name=${nsg2_name}
                ...    cats_org_name=${org_name}

    Run Keyword If  "${nsg.bootstrap_status}" != "ACTIVE"
    ...    Initiate Bootstrap Procedure For NSG2




*** Keywords ***
Initiate Bootstrap Procedure For NSG1
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

Initiate Bootstrap Procedure For NSG2
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
