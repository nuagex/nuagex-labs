*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Get NSGs status
    ${hq_nsg1} =  Get NSG
                  ...    name=${hq_nsg1_name}
                  ...    cats_org_name=${org_name}

    ${branch1_nsg1} =  Get NSG
                       ...    name=${branch1_nsg1_name}
                       ...    cats_org_name=${org_name}

    ${branch2_nsg1} =  Get NSG
                       ...    name=${branch2_nsg1_name}
                       ...    cats_org_name=${org_name}

    ${branch3_nsg1} =  Get NSG
                       ...    name=${branch3_nsg1_name}
                       ...    cats_org_name=${org_name}

    Set Suite Variable    ${hq_nsg1}
    Set Suite Variable    ${branch1_nsg1}
    Set Suite Variable    ${branch2_nsg1}
    Set Suite Variable    ${branch3_nsg1}


Setup SSH connections to Branch PCs and UtilVM
    ${util_conn} =  Linux.Connect To Server With Keys
                    ...    server_address=${util_mgmt_ip}
                    ...    username=root
                    ...    priv_key=${ssh_key_path}

    Set Global Variable    ${util_conn}

    ${br1pc1_conn} =  Linux.Connect To Server
                      ...    server_address=10.0.0.101
                      ...    server_login=centos
                      ...    server_password=Alcateldc
                      ...    prompt=~]$
                      ...    timeout=30

    Set Global Variable    ${br1pc1_conn}

    ${br2pc1_conn} =  Linux.Connect To Server
                      ...    server_address=10.0.0.102
                      ...    server_login=centos
                      ...    server_password=Alcateldc
                      ...    prompt=~]$
                      ...    timeout=30

    Set Global Variable    ${br2pc1_conn}

    ${br3pc1_conn} =  Linux.Connect To Server
                      ...    server_address=10.0.0.103
                      ...    server_login=centos
                      ...    server_password=Alcateldc
                      ...    prompt=~]$
                      ...    timeout=30

    Set Global Variable    ${br3pc1_conn}

    ${hqpc1_conn} =  Linux.Connect To Server
                      ...    server_address=10.0.0.111
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


Activate Branch2-NSG1
    Run Keyword If  "${branch2_nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${branch2_nsg1_name}
           ...    installer_pc_connection=${br2pc1_conn}


Activate Branch3-NSG1
    Run Keyword If  "${branch3_nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${branch3_nsg1_name}
           ...    installer_pc_connection=${br3pc1_conn}


Activate HQ-NSG1
    Run Keyword If  "${hq_nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${hq_nsg1_name}
           ...    installer_pc_connection=${hqpc1_conn}


Wait for all NSGs to reach boostrapped state
    Wait for NSG bootstrap
    ...    cats_org_name=${org_name}
    ...    cats_nsg_list=@[${hq_nsg1_name}, ${branch1_nsg1_name}, ${branch2_nsg1_name}, ${branch3_nsg1_name}]
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
