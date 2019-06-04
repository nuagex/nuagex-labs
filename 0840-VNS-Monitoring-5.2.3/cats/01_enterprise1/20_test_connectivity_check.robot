*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot

*** Test Cases ***
Update DHCP address for Branch PC1
    SSHLibrary.Switch Connection    ${brpc1_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

Update DHCP address for Branch PC2
    SSHLibrary.Switch Connection    ${brpc2_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

Sleep 1 minute before verifying datapath
    # its been seen that immediate traffic emission could fail
    Sleep    1m
