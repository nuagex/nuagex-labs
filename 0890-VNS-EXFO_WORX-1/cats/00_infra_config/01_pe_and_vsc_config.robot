*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Force Tags        pe-config

*** Test Cases ***
Configure VSC
    VSC.Login
    ...    vsc_address=${vsc-internet_mgmt_ip}
    ...    username=admin
    ...    password=Alcateldc
    ...    timeout=15

    SSHLibrary.Execute Command    bof static-route 10.10.0.0/16 next-hop 10.0.0.210
    SSHLibrary.Execute Command    bof save

Configure PE Internet
    Linux.Connect To Server With Keys
    ...    server_address=${pe-internet_mgmt_ip}
    ...    username=root
    ...    priv_key=${ssh_key_path}

    # enable IP routing
    SSHLibrary.Execute Command    sysctl -w net.ipv4.ip_forward=1
    ## make it persistent
    SSHLibrary.Execute Command
    ...    grep -q -F 'net.ipv4.ip_forward = 1' /usr/lib/sysctl.d/50-default.conf || echo 'net.ipv4.ip_forward = 1' >> /usr/lib/sysctl.d/50-default.conf

    # configure untagged dhcp-enabled interfaces (eth1, eth2...) that connects HQ, MV and NY underlays
    # eth0 is a management interface
    : FOR    ${INDEX}    IN RANGE    1    3
    \   ${ifcfg_file} =  CATSUtils.Render J2 Template
    \                    ...    source=${CURDIR}/data/pe_ifcfg.j2
                         ...    index=${INDEX}

    \   SSHLibrary.Execute Command    cat > /etc/sysconfig/network-scripts/ifcfg-eth${INDEX} <<EOF${\n}${ifcfg_file}${\n}EOF
    \   SSHLibrary.Execute Command    sudo ifdown eth${INDEX} && sudo ifup eth${INDEX}

    # transfer TC files
    SSHLibrary.Put File
    ...  source=${CURDIR}/data/start-tc.sh
    ...  destination=/root/tc-start.sh
    ...  mode=0755

    SSHLibrary.Put File
    ...  source=${CURDIR}/data/start-tc.sh
    ...  destination=/root/stop-tc.sh
    ...  mode=0755


    # iptables rules
    ## flush existing iptables rules
    SSHLibrary.Execute Command    iptables -t nat -F
    ## access dns on jumpbox  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    SSHLibrary.Execute Command    iptables -t nat -A POSTROUTING -o eth0 -p udp -d 10.0.0.1/32 --destination-port 53 -j SNAT --to-source ${pe-internet_mgmt_ip}
    ## access utility vm
    SSHLibrary.Execute Command    iptables -t nat -A POSTROUTING -o eth0 -d ${util_mgmt_ip}/32 -j SNAT --to-source ${pe-internet_mgmt_ip}
    # ## access vsc over its bof interface
    # SSHLibrary.Execute Command    iptables -t nat -A POSTROUTING -o eth0 -d ${vsc-internet_mgmt_ip}/32 -j SNAT --to-source ${pe-internet_mgmt_ip}
    ## NAT the internet traffic that is not destined to the local addressing
    ## should be only configured on the internet PE
    SSHLibrary.Execute Command    iptables -t nat -A POSTROUTING -o eth0 ! -d 10.0.0.0/8 -j MASQUERADE