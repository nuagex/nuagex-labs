*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot
Suite Setup       Login NuageX User

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
    ${br1pc1_conn} =  Linux.Connect To Server
                     ...    server_address=${branch_pc1_mgmt_addr}
                     ...    server_login=centos
                     ...    server_password=Alcateldc
                     ...    prompt=~]$
                     ...    timeout=30

    Set Global Variable    ${br1pc1_conn}

    ${br2pc1_conn} =  Linux.Connect To Server
                     ...    server_address=${branch_pc2_mgmt_addr}
                     ...    server_login=centos
                     ...    server_password=Alcateldc
                     ...    prompt=~]$
                     ...    timeout=30

    Set Global Variable    ${br2pc1_conn}

    ${util_conn} =  Linux.Connect To Server With Keys
                    ...    server_address=${util_mgmt_addr}
                    ...    username=root
                    ...    priv_key=${ssh_key_path}

    Set Global Variable    ${util_conn}

Launch NSG_1 activation process
    Run Keyword If  "${nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    nsg_name=${nsg1_name}
           ...    installer_pc_connection=${br1pc1_conn}

Launch NSG_2 activation process
    Run Keyword If  "${nsg2.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    nsg_name=${nsg2_name}
           ...    installer_pc_connection=${br2pc1_conn}


Wait for all NSGs to reach boostrapped state
    Wait for NSG bootstrap
    ...    cats_org_name=${org_name}
    ...    cats_nsg_list=@[${nsg1_name}, ${nsg1_name}]
    ...    cats_timeout=120


*** Keywords ***
Initiate NSG Bootstrap Procedure
    [Arguments]
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
