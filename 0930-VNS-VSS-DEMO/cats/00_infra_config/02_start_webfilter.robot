*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot

*** Test Cases ***
Start webserver
    Linux.Connect To Server With Keys
    ...    server_address=${hq_server_mgmt_addr}
    ...    username=root
    ...    priv_key=${ssh_key_path}

    # enable IP routing
    SSHLibrary.Execute Command  ip netns exec ns-data flask run --host=0.0.0.0