*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot

*** Test Cases ***
Create port forwarding to access Live Action VM
    # connect to jumpbox
    Linux.Connect To Server With Keys
    ...    server_address=${jumpbox_address}
    ...    username=admin
    ...    priv_key=${ssh_key_path}

    # port forwarding to access LiveAction
    SSHLibrary.Create Local SSH Tunnel
    ...  local_port=@{live_action_port_forwarding}[0]
    ...  remote_host=@{live_action_port_forwarding}[1]
    ...  remote_port=22


Configure Live Action
    Linux.Connect To Server With Keys
    ...    server_address=localhost
    ...    server_port=@{live_action_port_forwarding}[0]
    ...    username=ubuntu
    ...    priv_key=${ssh_key_path}

    # Create liveSP user and password
    SSHLibrary.Execute Command    pwd
