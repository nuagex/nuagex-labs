*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User
Force Tags        baseline-test
...               baseline-connectivity-test

*** Test Cases ***
Update DHCP address for HQ PC1
    SSHLibrary.Switch Connection    ${hqpc1_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True


Update DHCP address for Branch1 PC
    SSHLibrary.Switch Connection    ${branch1_pc1_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True



Sleep 60 sec before verifying datapath
    # its been seen that immediate traffic emission could fail
    Sleep    60s


Test connectivity between branches
    Linux.Ping.Execute Ping
    ...     host=${hq_pc1_data_addr}
    ...     count=4
    ...     timeout=4
    ...     verbose=True
    ...     net_ns=ns-data
    ...     sudo=True
