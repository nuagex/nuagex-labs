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

    # port forwarding to access Branch PC01
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{brpc1_port_forwarding}[0]
    ...    remote_host=@{brpc1_port_forwarding}[1]
    ...    remote_port=22

    # port forwarding to access Branch PC02
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{brpc2_port_forwarding}[0]
    ...    remote_host=@{brpc2_port_forwarding}[1]
    ...    remote_port=22