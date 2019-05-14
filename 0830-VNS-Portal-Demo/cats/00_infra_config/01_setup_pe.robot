*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Force Tags        pe-config

*** Test Cases ***
Configure PE Internet
    Linux.Connect To Server With Keys
    ...    server_address=${pe-router}
    ...    username=root
    ...    priv_key=${ssh_key_path}

    # enable IP routing
    SSHLibrary.Execute Command    sysctl -w net.ipv4.ip_forward=1
    ## make it persistent
    SSHLibrary.Execute Command
    ...    grep -q -F 'net.ipv4.ip_forward = 1' /usr/lib/sysctl.d/50-default.conf || echo 'net.ipv4.ip_forward = 1' >> /usr/lib/sysctl.d/50-default.conf

    # flap eth0 to apply the static route information
    SSHLibrary.Execute Command    sudo ifdown eth0 && sudo ifup eth0

    # configure untagged dhcp-enabled interfaces (eth1, eth2...) that connects HQ, MV and NY underlays
    # eth0 is a management interface
    : FOR    ${INDEX}    IN RANGE    1    4
    \   ${ifcfg_file} =  CATSUtils.Render J2 Template
    \                    ...    source=${CURDIR}/data/pe_ifcfg.j2
                         ...    index=${INDEX}

    \   SSHLibrary.Execute Command    cat > /etc/sysconfig/network-scripts/ifcfg-eth${INDEX} <<EOF${\n}${ifcfg_file}${\n}EOF
    \   SSHLibrary.Execute Command    sudo ifdown eth${INDEX} && sudo ifup eth${INDEX}

    # iptables rules
    ## flush existing iptables rules
    SSHLibrary.Execute Command    iptables -t nat -F
    ## access dns on jumpbox  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    SSHLibrary.Execute Command    iptables -t nat -A POSTROUTING -o eth0 -d 10.0.0.1/32 -j MASQUERADE
    ## access utility vm
    SSHLibrary.Execute Command    iptables -t nat -A POSTROUTING -o eth0 -d 10.0.0.33/32 -j MASQUERADE
    ## NAT the internet traffic that is not destined to the local addressing
    ## should be only configured on the internet PE
    SSHLibrary.Execute Command    iptables -t nat -A POSTROUTING -o eth0 ! -d 10.0.0.0/8 -j MASQUERADE

Configure VSC Internet
    VSC.Login
    ...    vsc_address=${vsc_mgmt_ip}
    ...    username=admin
    ...    password=admin

    VSC.Execute Command    /bof static-route ${mv_wan_network}  next-hop ${pe-router}
    VSC.Execute Command    /bof static-route ${ny_wan_network}  next-hop ${pe-router}
    VSC.Execute Command    /bof static-route ${hq_wan_network}  next-hop ${pe-router}
    VSC.Execute Command    /bof save

    VSC.Execute Command    /admin save