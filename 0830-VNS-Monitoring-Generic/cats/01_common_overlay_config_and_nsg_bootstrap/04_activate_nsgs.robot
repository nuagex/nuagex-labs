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

    # port forwarding to access ny PC1
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{br1pc1_port_forwarding}[0]
    ...    remote_host=@{br1pc1_port_forwarding}[1]
    ...    remote_port=22

    # port forwarding to access mv PC1
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{mvpc1_port_forwarding}[0]
    ...    remote_host=@{mvpc1_port_forwarding}[1]
    ...    remote_port=22

Get NSGs status
    ${mv_nsg1} =  Get NSG
                  ...    name=${mv_nsg1_name}
                  ...    cats_org_name=${org_name}

    ${ny_nsg1} =  Get NSG
                       ...    name=${ny_nsg1_name}
                       ...    cats_org_name=${org_name}

    Set Suite Variable    ${mv_nsg1}
    Set Suite Variable    ${ny_nsg1}


Setup addresses for CATS OUTSIDE provisioning
    [Tags]    cats_outside

    ${util_mgmt_addr} =  Set Variable    localhost
    ${util_mgmt_port} =  Set Variable    @{util_port_forwarding}[0]

    ${ny_pc1_mgmt_addr} =  Set Variable    localhost
    ${ny_pc1_mgmt_port} =  Set Variable    @{br1pc1_port_forwarding}[0]

    ${mv_pc1_mgmt_addr} =  Set Variable    localhost
    ${mv_pc1_mgmt_port} =  Set Variable    @{mvpc1_port_forwarding}[0]

    Set Suite Variable    ${ny_pc1_mgmt_addr}
    Set Suite Variable    ${ny_pc1_mgmt_port}
    Set Suite Variable    ${mv_pc1_mgmt_addr}
    Set Suite Variable    ${mv_pc1_mgmt_port}
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
                      ...    server_address=${ny_pc1_mgmt_addr}
                      ...    server_port=${ny_pc1_mgmt_port}
                      ...    server_login=centos
                      ...    server_password=Alcateldc
                      ...    prompt=~]$
                      ...    timeout=30

    Set Global Variable    ${br1pc1_conn}

    ${mvpc1_conn} =  Linux.Connect To Server
                      ...    server_address=${mv_pc1_mgmt_addr}
                      ...    server_port=${mv_pc1_mgmt_port}
                      ...    server_login=centos
                      ...    server_password=Alcateldc
                      ...    prompt=~]$
                      ...    timeout=30

    Set Global Variable    ${mvpc1_conn}

Activate NY-NSG
    Run Keyword If  "${ny_nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${ny_nsg1_name}
           ...    installer_pc_connection=${br1pc1_conn}


Activate MV-NSG
    Run Keyword If  "${mv_nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${mv_nsg1_name}
           ...    installer_pc_connection=${mvpc1_conn}


Wait for all NSGs to reach boostrapped state
    Wait for NSG bootstrap
    ...    cats_org_name=${org_name}
    ...    cats_nsg_list=@[${mv_nsg1_name}, ${ny_nsg1_name}]
    ...    cats_timeout=120
    ...    skip_controller_check=True


Connect to Mountain View PC and renew dhcp lease
    ${mv_pc_conn} =  Linux.Connect To Server
                      ...    server_address=localhost
                      ...    server_port=@{mvpc1_port_forwarding}[0]
                      ...    server_login=root
                      ...    server_password=Alcateldc
                      ...    timeout=30s
    Set Suite Variable    ${mv_pc_conn}

Connect to Namespace and Renew DHCP client lease 
    SSHLibrary.Execute Command    ip netns exec ns-data bash -c "dhclient eth1"

Connect to New York PC and renew dhcp lease
    ${ny_pc_conn} =  Linux.Connect To Server
                      ...    server_address=localhost
                      ...    server_port=@{br1pc1_port_forwarding}[0]
                      ...    server_login=root
                      ...    server_password=Alcateldc
                      ...    timeout=30s
    Set Suite Variable    ${ny_pc_conn}

Connect to Namespace and Renew DHCP client lease  
    SSHLibrary.Execute Command    ip netns exec ns-data bash -c "dhclient eth1"

















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
