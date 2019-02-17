*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Set up port forwarding
    [Tags]    cats_outside

    Linux.Connect To Server With Keys
    ...    server_address=${jumpbox_address}
    ...    username=admin
    ...    priv_key=${ssh_key_path}

    # port forwarding to access util VM
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{util_port_forwarding}[0]
    ...    remote_host=@{util_port_forwarding}[1]
    ...    remote_port=22

    # port forwarding to access Branch1 PC1
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{br1pc1_port_forwarding}[0]
    ...    remote_host=@{br1pc1_port_forwarding}[1]
    ...    remote_port=22

    # port forwarding to access HQ PC1
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{hqpc1_port_forwarding}[0]
    ...    remote_host=@{hqpc1_port_forwarding}[1]
    ...    remote_port=22

Get NSGs status
    ${hq_nsg1} =  Get NSG
                  ...    name=${hq_nsg1_name}
                  ...    cats_org_name=${org_name}

    ${branch1_nsg1} =  Get NSG
                       ...    name=${branch1_nsg1_name}
                       ...    cats_org_name=${org_name}

    Set Suite Variable    ${hq_nsg1}
    Set Suite Variable    ${branch1_nsg1}


Setup addresses for CATS OUTSIDE provisioning
    [Tags]    cats_outside

    ${util_mgmt_addr} =  Set Variable    localhost
    ${util_mgmt_port} =  Set Variable    @{util_port_forwarding}[0]

    ${branch1_pc1_mgmt_addr} =  Set Variable    localhost
    ${branch1_pc1_mgmt_port} =  Set Variable    @{br1pc1_port_forwarding}[0]

    ${hq_pc1_mgmt_addr} =  Set Variable    localhost
    ${hq_pc1_mgmt_port} =  Set Variable    @{hqpc1_port_forwarding}[0]

    Set Suite Variable    ${branch1_pc1_mgmt_addr}
    Set Suite Variable    ${branch1_pc1_mgmt_port}
    Set Suite Variable    ${hq_pc1_mgmt_addr}
    Set Suite Variable    ${hq_pc1_mgmt_port}
    Set Suite Variable    ${util_mgmt_addr}
    Set Suite Variable    ${util_mgmt_port}


Setup SSH connections to Branch PCs and UtilVM
    ${util_conn} =  Linux.Connect To Server
                    ...    server_address=${util_mgmt_addr}
                    ...    server_port=${util_mgmt_port}
                    ...    server_login=root
                    ...    server_password=Alcateldc

    Set Global Variable    ${util_conn}

    ${br1pc1_conn} =  Linux.Connect To Server
                      ...    server_address=${branch1_pc1_mgmt_addr}
                      ...    server_port=${branch1_pc1_mgmt_port}
                      ...    server_login=centos
                      ...    server_password=Alcateldc
                      ...    prompt=~]$
                      ...    timeout=30

    Set Global Variable    ${br1pc1_conn}

    ${hqpc1_conn} =  Linux.Connect To Server
                      ...    server_address=${hq_pc1_mgmt_addr}
                      ...    server_port=${hq_pc1_mgmt_port}
                      ...    server_login=centos
                      ...    server_password=Alcateldc
                      ...    prompt=~]$
                      ...    timeout=30

    Set Global Variable    ${hqpc1_conn}

Activate Branch1-NSG1
    Run Keyword If  "${branch1_nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${branch1_nsg1_name}
           ...    installer_pc_connection=${br1pc1_conn}


Activate HQ-NSG1
    Run Keyword If  "${hq_nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${hq_nsg1_name}
           ...    installer_pc_connection=${hqpc1_conn}


Wait for all NSGs to reach boostrapped state
    Wait for NSG bootstrap
    ...    cats_org_name=${org_name}
    ...    cats_nsg_list=@[${hq_nsg1_name}, ${branch1_nsg1_name}]
    ...    cats_timeout=120
    ...    skip_controller_check=True


















*** Keywords ***
Initiate NSG Bootstrap Procedure
    [Arguments]
    ...    ${org_name}=${None}
    ...    ${nsg_name}=${None}
    ...    ${installer_pc_connection}=${None}

    ${activation_url} =  Get activation link for NSG
                         ...    org_name=${org_name}
                         ...    nsg_name=${nsg_name}

    SSHLibrary.Switch Connection    ${installer_pc_connection}

    # make sure to update IP address
    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

    linux.Execute Command Over SSH And Maintain Shell
    ...    sudo ip netns exec ns-data python /opt/nsg_bootstrap/nsg_bootstrap.py ${activation_url} > /tmp/bootstrap_${nsg_name}.txt 2>&1 &
    # ...    sudo=True
            #  ...    return_rc=True
    # Log    ${stdout}
    # Should Be Equal   ${rc}    ${0}
    # Sleep    1

Get activation link for NSG
    [Arguments]
    ...    ${org_name}=${None}
    ...    ${nsg_name}=${None}

    SSHLibrary.Switch Connection    ${util_conn}

    NSG.Send NSG Activation
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${nsg_name}

    Sleep    2

    ${activation_url} =  NSG.Get Activation Link From na.log
                         ...    verbose=True

    [Return]    ${activation_url}
