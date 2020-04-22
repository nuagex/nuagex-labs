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
    ...  recursive=True

    SSHLibrary.Put File
    ...  source=${CURDIR}/files/webserver.service
    ...  destination=/etc/systemd/system
    

    SSHLibrary.Execute Command  pip install gunicorn flask

    SSHLibrary.Execute Command  systemctl enable webserver.service

    SSHLibrary.Execute Command  systemctl start webserver.service