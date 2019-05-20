*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Connect to ES VM
    ${conn} =  Linux.Connect To Server With Keys
               ...    server_address=${es_mgmt_ip}
               ...    username=root
               ...    priv_key=${ssh_key_path}

Copy Snapshot file
    SSHLibrary.Execute Command
    ...  /usr/local/bin/delete.sh
    ...  shell=True
    ...  sudo=True