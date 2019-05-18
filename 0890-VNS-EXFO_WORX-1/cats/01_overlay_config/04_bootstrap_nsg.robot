*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User
Force Tags        baseline-nsg-bootstrap

*** Test Cases ***
Get NSGs status
    ${hq_nsg1} =  Get NSG
                  ...  name=${hq_nsg1_name}
                  ...  cats_org_name=${org_name}

    ${branch1_nsg1} =  Get NSG
                       ...  name=${branch1_nsg1_name}
                       ...  cats_org_name=${org_name}

    Set Suite Variable    ${hq_nsg1}
    Set Suite Variable    ${branch1_nsg1}


Verify NSGs booted up
    # connect to PE to ping NSGs WAN IP addresses
    Linux.Connect To Server With Keys
    ...    server_address=${pe-internet_mgmt_ip}
    ...    username=root
    ...    priv_key=${ssh_key_path}

    ${ips} =  Create List
              ...  10.10.90.10
              ...  10.10.10.10

    CATSUtils.Wait For All Hosts To Be Reachable
    ...    hosts=${ips}
    ...    timeout=120


Setup SSH connections to Branch PCs and UtilVM
    ${util_conn} =  Linux.Connect To Server With Keys
                    ...    server_address=${util_mgmt_ip}
                    ...    username=root
                    ...    priv_key=${ssh_key_path}

    Set Global Variable    ${util_conn}

    ${hqpc1_conn} =  Linux.Connect To Server
                      ...    server_address=${hq_pc1_mgmt_addr}
                      ...    server_login=centos
                      ...    server_password=Alcateldc
                      ...    prompt=~]$
                      ...    timeout=30

    Set Global Variable    ${hqpc1_conn}

    ${branch1_pc1_conn} =  Linux.Connect To Server
                           ...    server_address=${branch1_pc1_mgmt_addr}
                           ...    server_login=centos
                           ...    server_password=Alcateldc
                           ...    prompt=~]$
                           ...    timeout=30

    Set Global Variable    ${branch1_pc1_conn}


Launch HQ-NSG1 activation process
    Run Keyword If  "${hq_nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${hq_nsg1_name}
           ...    installer_pc_connection=${hqpc1_conn}


Launch Branch1-NSG1 activation process
    Run Keyword If  "${branch1_nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${branch1_nsg1_name}
           ...    installer_pc_connection=${branch1_pc1_conn}



Wait for all NSGs to reach bootstrapped state
    Wait for NSG bootstrap
    ...    cats_org_name=${org_name}
    ...    cats_nsg_list=@[${hq_nsg1_name}, ${branch1_nsg1_name}]
    ...    cats_timeout=180


















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