*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Update DHCP address for Branch PC1
    SSHLibrary.Switch Connection    ${br1pc1_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

Update DHCP address for Branch PC2
    SSHLibrary.Switch Connection    ${br2pc1_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

Sleep 15 sec before verifying datapath
    # its been seen that immediate traffic emission could fail
    Sleep    15s

Test connectivity between branches
    Linux.Ping.Execute Ping
    ...     host=${branch_pc1_data_addr}
    ...     count=4
    ...     timeout=4
    ...     verbose=True
    ...     net_ns=ns-data
    ...     sudo=True