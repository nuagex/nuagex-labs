*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Connect LiveSP VM 
    Linux.Connect To Server
        ...    server_address=${livesp_mgmt_ip}
        ...    server_login=livesp
        ...    server_password=livesp
        ...    prompt=~$
        ...    timeout=30

## Re-Install LiveSP
Re Install LiveSP
    SSHLibrary.Execute Command    docker swarm leave 
    SSHLibrary.Execute Command    docker rm -vf  registry_registry_1 
    SSHLibrary.Execute Command    livesp-install -m "Re-install setup"

## This is a knowsn Bug team is aware of this. 