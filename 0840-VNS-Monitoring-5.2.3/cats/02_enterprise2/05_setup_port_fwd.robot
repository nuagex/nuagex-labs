*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot

*** Test Cases ***
Configure portforwarding rules
    Linux.Connect To Server With Keys
    ...    server_address=${jumpbox_address}
    ...    username=admin
    ...    priv_key=${ssh_key_path}

    # port forwarding to access util VM
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{util_port_forwarding}[0]
    ...    remote_host=@{util_port_forwarding}[1]
    ...    remote_port=22

    # port forwarding to access Branch PC03
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{brpc3_port_forwarding}[0]
    ...    remote_host=@{brpc3_port_forwarding}[1]
    ...    remote_port=22

    # port forwarding to access Branch PC04
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{brpc4_port_forwarding}[0]
    ...    remote_host=@{brpc4_port_forwarding}[1]
    ...    remote_port=22

    # port forwarding to access Branch PC05
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{brpc5_port_forwarding}[0]
    ...    remote_host=@{brpc5_port_forwarding}[1]
    ...    remote_port=22
