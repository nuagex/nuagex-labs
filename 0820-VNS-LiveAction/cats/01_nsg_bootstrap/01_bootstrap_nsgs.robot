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

    # port forwarding to access Edison PC1
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{edison_pc_port_forwarding}[0]
    ...    remote_host=@{edison_pc_port_forwarding}[1]
    ...    remote_port=22

    # port forwarding to access Sac PC1
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{sac_pc_port_forwarding}[0]
    ...    remote_host=@{sac_pc_port_forwarding}[1]
    ...    remote_port=22

Get NSGs status
    ${sac_nsg} =  Get NSG
                  ...    name=${sac_nsg_name} 
                  ...    cats_org_name=${org_name}

    ${edison_nsg} =  Get NSG
                       ...    name=${edison_nsg_name} 
                       ...    cats_org_name=${org_name}

    Set Suite Variable    ${sac_nsg}
    Set Suite Variable    ${edison_nsg}


Setup addresses for CATS OUTSIDE provisioning
    [Tags]    cats_outside

    ${util_mgmt_addr} =  Set Variable    localhost
    ${util_mgmt_port} =  Set Variable    @{util_port_forwarding}[0]

    ${sac_pc_mgmt_addr} =  Set Variable    localhost
    ${sac_pc_mgmt_port} =  Set Variable    @{sac_pc_port_forwarding}[0]

    ${edison_pc_mgmt_addr} =  Set Variable    localhost
    ${edison_pc_mgmt_port} =  Set Variable    @{edison_pc_port_forwarding}[0]

    Set Suite Variable    ${sac_pc_mgmt_addr}
    Set Suite Variable    ${sac_pc_mgmt_port}
    Set Suite Variable    ${edison_pc_mgmt_addr}
    Set Suite Variable    ${edison_pc_mgmt_port}
    Set Suite Variable    ${util_mgmt_addr}
    Set Suite Variable    ${util_mgmt_port}


Setup SSH connections to Branch PCs and UtilVM
    ${util_conn} =  Linux.Connect To Server
                    ...    server_address=${util_mgmt_addr}
                    ...    server_port=${util_mgmt_port}
                    ...    server_login=root
                    ...    server_password=Alcateldc

    Set Global Variable    ${util_conn}

    ${sac_pc_conn} =  Linux.Connect To Server With Keys
                      ...    server_address=${sac_pc_mgmt_addr}
                      ...    server_port=${sac_pc_mgmt_port}
                      ...    username=centos
                      ...    priv_key=${ssh_key_path}
                      ...    prompt=~]$
                      ...    timeout=30

    Set Global Variable    ${sac_pc_conn}

    ${edison_pc_conn} =  Linux.Connect To Server With Keys
                         ...    server_address=${edison_pc_mgmt_addr}
                         ...    server_port=${edison_pc_mgmt_port}
                         ...    username=centos
                         ...    priv_key=${ssh_key_path}
                         ...    prompt=~]$
                         ...    timeout=30

    Set Global Variable   ${edison_pc_conn}

Activate Sac NSG
    Run Keyword If  "${sac_nsg.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${sac_nsg_name}
           ...    installer_pc_connection= ${sac_pc_conn}


Activate Edison NSG
    Run Keyword If  "${edison_nsg.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${edison_nsg_name}
           ...    installer_pc_connection=${edison_pc_conn}


Wait for all NSGs to reach boostrapped state
    Wait for NSG bootstrap
    ...    cats_org_name=${org_name}
    ...    cats_nsg_list=@[${sac_nsg_name}, ${edison_nsg_name}]
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