*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Get NSGs status
    ${hq_sf_nsg1} =  Get NSG
                       ...    name=${hq_sf_nsg1_name}
                       ...    cats_org_name=${org_name}
    ${pa_nsg1} =  Get NSG
                  ...    name=${pa_nsg1_name}
                  ...    cats_org_name=${org_name}

    ${sj_nsg1} =  Get NSG
                       ...    name=${sj_nsg1_name}
                       ...    cats_org_name=${org_name}

    Set Suite Variable    ${hq_sf_nsg1}
    Set Suite Variable    ${pa_nsg1}
    Set Suite Variable    ${sj_nsg1}

Verify NSGs booted up
    # connect to PE Internet to ping NSGs WAN IP addresses
    Linux.Connect To Server With Keys
    ...    server_address=${pe-router}
    ...    username=root
    ...    priv_key=${ssh_key_path}

    ${ips} =  Create List
              ...  ${hq_sf_nsg1_wan1_ip}
              ...  ${pa_nsg1_wan1_ip}
              ...  ${sj_nsg1_wan1_ip}

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
                      ...    server_login=root
                      ...    server_password=Alcateldc
                      ...    prompt=~]#
                      ...    timeout=30

    Set Global Variable    ${hqpc1_conn}

    ${hqserver_conn} =  Linux.Connect To Server
                      ...    server_address=${hq_server_mgmt_addr}
                      ...    server_login=root
                      ...    server_password=Alcateldc
                      ...    prompt=~]#
                      ...    timeout=30

    Set Global Variable    ${hqserver_conn}

    ${papc1_conn} =  Linux.Connect To Server
                      ...    server_address=${pa_pc1_mgmt_addr}
                      ...    server_login=root
                      ...    server_password=Alcateldc
                      ...    prompt=~]#
                      ...    timeout=30

    Set Global Variable    ${papc1_conn}

    ${patablet_conn} =  Linux.Connect To Server
                      ...    server_address=${pa_tablet_mgmt_addr}
                      ...    server_login=root
                      ...    server_password=Alcateldc
                      ...    prompt=~]#
                      ...    timeout=30

    Set Global Variable    ${patablet_conn}

    ${sjpc1_conn} =  Linux.Connect To Server
                      ...    server_address=${sj_pc1_mgmt_addr}
                      ...    server_login=root
                      ...    server_password=Alcateldc
                      ...    prompt=~]#
                      ...    timeout=30

    Set Global Variable    ${sjpc1_conn}

    ${sjmobile_conn} =  Linux.Connect To Server
                      ...    server_address=${sj_mobile_mgmt_addr}
                      ...    server_login=root
                      ...    server_password=Alcateldc
                      ...    prompt=~]#
                      ...    timeout=30

    Set Global Variable    ${sjmobile_conn}

Launch HQ-NSG1 activation process
    Run Keyword If  "${hq_sf_nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${hq_sf_nsg1_name}
           ...    installer_pc_connection=${hqpc1_conn}


Launch PA-NSG1 activation process
    Run Keyword If  "${pa_nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${pa_nsg1_name}
           ...    installer_pc_connection=${papc1_conn}

Launch SJ-NSG1 activation process
    Run Keyword If  "${sj_nsg1.bootstrap_status}" != "ACTIVE"
    ...    Initiate NSG Bootstrap Procedure
           ...    org_name=${org_name}
           ...    nsg_name=${sj_nsg1_name}
           ...    installer_pc_connection=${sjpc1_conn}

Wait for all NSGs to reach boostrapped state
    Wait for NSG bootstrap
    ...    cats_org_name=${org_name}
    ...    cats_nsg_list=@[${hq_sf_nsg1_name}, ${pa_nsg1_name}, ${sj_nsg1_name}]
    ...    cats_timeout=180
    ...    skip_controller_check=True

Update NSGs Address
    Update NSG Location
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${hq_sf_nsg1_name}
    ...    address=${hq_sf_nsg1_address}

    Update NSG Location
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${pa_nsg1_name}
    ...    address=${pa_nsg1_address}
    
    Update NSG Location
    ...    cats_org_name=${org_name}
    ...    cats_nsg_name=${sj_nsg1_name}
    ...    address=${sj_nsg1_address}


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