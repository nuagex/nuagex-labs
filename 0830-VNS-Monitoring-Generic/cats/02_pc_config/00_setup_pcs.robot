*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot

*** Test Cases ***
Create port forwarding rules to access Mountain View and New York PCs
    # connect to jumpbox
    Linux.Connect To Server With Keys
    ...  server_address=${jumpbox_address}
    ...  username=admin
    ...  priv_key=${ssh_key_path}

    # port forwarding to access Mountain View PC
    SSHLibrary.Create Local SSH Tunnel
    ...  local_port=@{hqpc1_port_forwarding}[0]
    ...  remote_host=@{hqpc1_port_forwarding}[1]
    ...  remote_port=22

    # port forwarding to access New York PC
    SSHLibrary.Create Local SSH Tunnel
    ...  local_port=@{br1pc1_port_forwarding} [0]
    ...  remote_host=@{br1pc1_port_forwarding} [1]
    ...  remote_port=22

Connect to Mountain View PC and renew dhcp lease
    ${mv_pc_conn} =  Linux.Connect To Server
                      ...    server_address=localhost
                      ...    server_port=@{hqpc1_port_forwarding}[0]
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