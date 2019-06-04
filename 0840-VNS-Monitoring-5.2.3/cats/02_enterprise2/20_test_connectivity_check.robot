*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot

*** Test Cases ***
Update DHCP address for Branch PC3
    SSHLibrary.Switch Connection    ${brpc3_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

Update DHCP address for Branch PC4
    SSHLibrary.Switch Connection    ${brpc4_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

Update DHCP address for Branch PC5
    SSHLibrary.Switch Connection    ${brpc5_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True
