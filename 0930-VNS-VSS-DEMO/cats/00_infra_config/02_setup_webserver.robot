*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot

*** Test Cases ***
Set up HQ Server
    ${hqserver_conn} =  Linux.Connect To Server
                        ...    server_address=${hq_server_mgmt_addr}
                        ...    server_login=root
                        ...    server_password=Alcateldc
                        ...    prompt=~]#
                        ...    timeout=30
    SSHLibrary.Put Directory
    ...  source=${CURDIR}/files/webserver
    ...  destination=/root

    # enable IP routing
    SSHLibrary.Execute Command  ip netns exec ns-data flask run --host=0.0.0.0