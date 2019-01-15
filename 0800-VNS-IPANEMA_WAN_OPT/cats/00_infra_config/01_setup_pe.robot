*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot

*** Test Cases ***
Create port forwarding to access PE Internet
    # connect to jumpbox
    Linux.Connect To Server With Keys
    ...    server_address=${jumpbox_address}
    ...    username=admin
    ...    priv_key=${ssh_key_path}

    # port forwarding to access PE Internet
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{pe_internet_port_forwarding}[0]
    ...    remote_host=@{pe_internet_port_forwarding}[1]
    ...    remote_port=22


Configure PE Internet
    Linux.Connect To Server With Keys
    ...    server_address=localhost
    ...    server_port=@{pe_internet_port_forwarding}[0]
    ...    username=root
    ...    priv_key=${ssh_key_path}

    # enable IP routing
    SSHLibrary.Execute Command    sysctl -w net.ipv4.ip_forward=1
    ## make it persistent
    SSHLibrary.Execute Command
    ...    grep -q -F 'net.ipv4.ip_forward = 1' /usr/lib/sysctl.d/50-default.conf || echo 'net.ipv4.ip_forward = 1' >> /usr/lib/sysctl.d/50-default.conf

    # configure untagged dhcp-enabled interfaces (eth1-eth4)
    : FOR    ${INDEX}    IN RANGE    1    5
    \   ${ifcfg_file} =  CATSUtils.Render J2 Template
    \                    ...    source=${CURDIR}/data/pe_ifcfg.txt
                         ...    index=${INDEX}
    
    \   SSHLibrary.Execute Command    cat > /etc/sysconfig/network-scripts/ifcfg-eth${INDEX} <<EOF${\n}${ifcfg_file}${\n}EOF
    \   SSHLibrary.Execute Command    ifup eth${INDEX}

    # iptables rules
    ## flush existing iptables rules
    SSHLibrary.Execute Command    iptables -t nat -F
    ## access dns on jumpbox
    SSHLibrary.Execute Command    iptables -t nat -A POSTROUTING -o eth0 -d 10.0.0.1/32 -j MASQUERADE
    ## access utility vm
    SSHLibrary.Execute Command    iptables -t nat -A POSTROUTING -o eth0 -d 10.0.0.33/32 -j MASQUERADE
    ## NAT the internet traffic that is not destined to the local addressing
    ## should be only configured on the internet PE
    SSHLibrary.Execute Command    iptables -t nat -A POSTROUTING -o eth0 ! -d 10.0.0.0/8 -j MASQUERADE
