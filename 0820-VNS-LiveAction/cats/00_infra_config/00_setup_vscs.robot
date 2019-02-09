*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot

*** Test Cases ***
Create port forwarding rules to access VSD and VSC
    # connect to jumpbox
    Linux.Connect To Server With Keys
    ...    server_address=${jumpbox_address}
    ...    username=admin
    ...    priv_key=${ssh_key_path}

    # port forwarding to access VSD
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{vsd_port_forwarding}[0]
    ...    remote_host=@{vsd_port_forwarding}[1]
    ...    remote_port=22

    # port forwarding to access VSC Internet
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{vsci_port_forwarding}[0]
    ...    remote_host=@{vsci_port_forwarding}[1]
    ...    remote_port=22


Connect to VSD
    ${vsd_conn} =  Linux.Connect To Server
                    ...    server_address=localhost
                    ...    server_port=@{vsd_port_forwarding}[0]
                    ...    server_login=root
                    ...    server_password=Alcateldc
                    ...    timeout=30s
    Set Suite Variable    ${vsd_conn}

Generate VSC Internet certificates
    [Tags]  vsc_certs
    # for vsc-i
    SSHLibrary.Write
    ...    /opt/vsd/ejbca/deploy/certMgmt.sh -a generate -u ${vsc-internet_hostname} -c ${vsc-internet_hostname} -d ${vsd_fqdn} -f pem -t server -o csp -s admin@${vsc-i_mgmt_ip}:/

    SSHLibrary.Read Until Regexp
    ...    password:

    SSHLibrary.Write    admin${\n}


Configure VSC Internet
    ${vsci_conn} =  VSC.Login
                    ...    vsc_address=localhost
                    ...    username=admin
                    ...    password=admin
                    ...    port=@{vsci_port_forwarding}[0]
    Set Suite Variable    ${vsci_conn}

    VSC.Execute Command    /configure system name ${vsc-internet_hostname}
    VSC.Execute Command    /bof primary-dns 10.0.0.1
    VSC.Execute Command    /bof dns-domain nuage.lab
    VSC.Execute Command    /bof save

    VSC.Execute Command    ping count 1 ${vsd_fqdn} router "management"
    VSC.Execute Command    configure vswitch-controller xmpp-server ${vsc-internet_hostname}:${vsc-internet_hostname}@${vsd_fqdn}

    # Enable TLS
    VSC.Execute Command    /configure system security tls-profile ex-tls-profile create
    VSC.Execute Command    /configure system security tls-profile ex-tls-profile own-key cf1:\\${vsc-internet_hostname}-Key.pem
    VSC.Execute Command    /configure system security tls-profile ex-tls-profile own-certificate cf1:\\${vsc-internet_hostname}.pem
    VSC.Execute Command    /configure system security tls-profile ex-tls-profile ca-certificate cf1:\\${vsc-internet_hostname}-CA.pem
    VSC.Execute Command    /configure system security tls-profile ex-tls-profile no shutdown
    VSC.Execute Command    /configure vswitch-controller open-flow tls-profile "ex-tls-profile"
    VSC.Execute Command    /configure vswitch-controller xmpp tls-profile "ex-tls-profile"

    # Enable NTP server
    VSC.Execute Command    /configure system time ntp ntp-server

    # Configure control interface
    VSC.Execute Command    /configure router interface control address ${vsc-i_control_ip}/24
    VSC.Execute Command    /configure router static-route 10.10.0.0/16 next-hop ${hq_internet_gw_ip}

    VSC.Execute Command    /admin save
