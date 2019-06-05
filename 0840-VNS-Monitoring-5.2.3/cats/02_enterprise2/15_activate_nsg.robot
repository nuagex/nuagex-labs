*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot

*** Test Cases ***
Setup SSH connections to Branch PCs
    ${brpc3_conn} =  Linux.Connect To Server
                     ...    server_address=localhost
                     ...    server_port=@{brpc3_port_forwarding}[0]
                     ...    server_login=root
                     ...    server_password=Alcateldc

    Set Global Variable    ${brpc3_conn}

    ${brpc4_conn} =  Linux.Connect To Server
                     ...    server_address=localhost
                     ...    server_port=@{brpc4_port_forwarding}[0]
                     ...    server_login=root
                     ...    server_password=Alcateldc

    Set Global Variable    ${brpc4_conn}

    ${brpc5_conn} =  Linux.Connect To Server
                     ...    server_address=localhost
                     ...    server_port=@{brpc5_port_forwarding}[0]
                     ...    server_login=root
                     ...    server_password=Alcateldc

    Set Global Variable    ${brpc5_conn}

Activate NSG3
    ${nsg} =    Get NSG
                ...    name=${nsg3_name}
                ...    cats_org_name=${org_name}

    Run Keyword If  "${nsg.bootstrap_status}" != "ACTIVE"
    ...    Initiate Bootstrap Procedure For NSG3

Activate NSG4
    ${nsg} =    Get NSG
                ...    name=${nsg4_name}
                ...    cats_org_name=${org_name}

    Run Keyword If  "${nsg.bootstrap_status}" != "ACTIVE"
    ...    Initiate Bootstrap Procedure For NSG4

Activate NSG5
    ${nsg} =    Get NSG
                ...    name=${nsg5_name}
                ...    cats_org_name=${org_name}

    Run Keyword If  "${nsg.bootstrap_status}" != "ACTIVE"
    ...    Initiate Bootstrap Procedure For NSG5



*** Keywords ***
Initiate Bootstrap Procedure For NSG3
    SSHLibrary.Switch Connection    ${brpc3_conn}

    # make sure to update IP address
    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

    ${stdout}  ${rc} =  SSHLibrary.Execute Command
                        ...    ip netns exec ns-data python /opt/nsg_bootstrap/nsg_bootstrap.py ${activation_url3}
                        ...    sudo=True
                        ...    return_stdout=True
                        ...    return_rc=True
    Log    ${stdout}
    Should Be Equal   ${rc}    ${0}

Initiate Bootstrap Procedure For NSG4
    SSHLibrary.Switch Connection    ${brpc4_conn}

    # make sure to update IP address
    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

    ${stdout}  ${rc} =  SSHLibrary.Execute Command
                        ...    ip netns exec ns-data python /opt/nsg_bootstrap/nsg_bootstrap.py ${activation_url4}
                        ...    sudo=True
                        ...    return_stdout=True
                        ...    return_rc=True
    Log    ${stdout}
    Should Be Equal   ${rc}    ${0}

Initiate Bootstrap Procedure For NSG5
    SSHLibrary.Switch Connection    ${brpc5_conn}

    # make sure to update IP address
    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

    ${stdout}  ${rc} =  SSHLibrary.Execute Command
                        ...    ip netns exec ns-data python /opt/nsg_bootstrap/nsg_bootstrap.py ${activation_url5}
                        ...    sudo=True
                        ...    return_stdout=True
                        ...    return_rc=True
    Log    ${stdout}
    Should Be Equal   ${rc}    ${0}
