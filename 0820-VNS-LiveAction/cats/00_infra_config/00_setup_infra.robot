*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot

*** Test Cases ***
Create port forwarding rules to access VSD VSC and Util
    # connect to jumpbox
    Linux.Connect To Server With Keys
    ...  server_address=${jumpbox_address}
    ...  username=admin
    ...  priv_key=${ssh_key_path}

    # port forwarding to access VSD
    SSHLibrary.Create Local SSH Tunnel
    ...  local_port=@{vsd_port_forwarding}[0]
    ...  remote_host=@{vsd_port_forwarding}[1]
    ...  remote_port=22

    # port forwarding to access VSC
    SSHLibrary.Create Local SSH Tunnel
    ...  local_port=@{vsc_port_forwarding}[0]
    ...  remote_host=@{vsc_port_forwarding}[1]
    ...  remote_port=22

    # port forwarding to access Portal VM
    SSHLibrary.Create Local SSH Tunnel
    ...  local_port=@{portal_port_forwarding}[0]
    ...  remote_host=@{portal_port_forwarding}[1]
    ...  remote_port=22

    # port forwarding to access Util VM
    SSHLibrary.Create Local SSH Tunnel
    ...  local_port=@{util_port_forwarding}[0]
    ...  remote_host=@{util_port_forwarding}[1]
    ...  remote_port=22

Connect to Jumpbox
    Linux.Connect To Server With Keys
    ...  server_address=${jumpbox_address}
    ...  username=admin
    ...  priv_key=${ssh_key_path} 

Add Iptables Rules
    SSHLibrary.Execute Command  sudo iptables -t nat -I POSTROUTING 1 -s 10.0.0.0/8 ! -d 10.0.0.0/8 -p udp --dport 4789 -j MASQUERADE --to-ports 2050-3050
    SSHLibrary.Execute Command  sudo iptables -t nat -I POSTROUTING 1 -s 10.0.0.0/8 ! -d 10.0.0.0/8 -p udp --dport 4500 -j MASQUERADE --to-ports 3060-4060
    SSHLibrary.Execute Command  sudo service iptables save
    SSHLibrary.Execute Command  sudo ip route add 10.10.0.0/24 via 10.0.0.4 dev eth1


Connect to VSD and generate VSC certificate
    ${vsd_conn} =  Linux.Connect To Server
                    ...    server_address=localhost
                    ...    server_port=@{vsd_port_forwarding}[0]
                    ...    server_login=root
                    ...    server_password=Alcateldc
                    ...    timeout=30s
    Set Suite Variable    ${vsd_conn}


Revoke existing VSC certificates
    # for vsc
    SSHLibrary.Execute Command
    ...  /opt/vsd/ejbca/deploy/certMgmt.sh -a revoke -u ${vsc-hostname} -c ${vsc-hostname} -o csp -d ${vsd_fqdn}


Generate VSC certificates
    # for vsc
    SSHLibrary.Write
    ...  /opt/vsd/ejbca/deploy/certMgmt.sh -a generate -u ${vsc-hostname} -c ${vsc-hostname} -d ${vsd_fqdn} -f pem -t server -o csp -s admin@${vsc-mgmt_ip}:/

    SSHLibrary.Read Until Regexp
    ...  password:

    SSHLibrary.Write  admin${\n}

Configure VSC
    ${vsc_conn} =  VSC.Login
                    ...    vsc_address=localhost
                    ...    username=admin
                    ...    password=admin
                    ...    port=@{vsc_port_forwarding}[0]
    Set Suite Variable    ${vsc_conn}

    VSC.Execute Command  ping count 1 ${vsd_fqdn} router "management"

    ## Diable Existing TLS
    VSC.Execute Command  /configure vswitch-controller open-flow no tls-profile
    VSC.Execute Command  /configure vswitch-controller xmpp no tls-profile
    VSC.Execute Command  /configure system security tls-profile "ex-tls-profile" shutdown
    VSC.Execute Command  /configure system security no tls-profile "ex-tls-profile"


    # Enable TLS
    VSC.Execute Command  /configure system security tls-profile "TLS-profile" create
    VSC.Execute Command  /configure system security tls-profile "TLS-profile" own-key cf1:\\${vsc-hostname}-Key.pem
    VSC.Execute Command  /configure system security tls-profile "TLS-profile" own-certificate cf1:\\${vsc-hostname}.pem
    VSC.Execute Command  /configure system security tls-profile "TLS-profile" ca-certificate cf1:\\${vsc-hostname}-CA.pem
    VSC.Execute Command  /configure system security tls-profile "TLS-profile" no shutdown
    VSC.Execute Command  /configure vswitch-controller no xmpp-server
    VSC.Execute Command  /configure vswitch-controller xmpp tls-profile "TLS-profile"
    VSC.Execute Command  /configure vswitch-controller open-flow tls-profile "TLS-profile"
    VSC.Execute Command  /configure vswitch-controller xmpp-server ${vsc-hostname}:${vsc-hostname}@${vsd_fqdn}

    # Enable NTP server
    VSC.Execute Command  /configure system time ntp ntp-server
    VSC.Execute Command  /configure system time ntp server 10.0.0.2
    VSC.Execute Command  /configure system time ntp no shutdown


    # Configure control interface
    VSC.Execute Command  /configure router static-route 0.0.0.0/0 next-hop 10.0.0.1

    VSC.Execute Command  /admin save

Connect to VSD and generate Util certificate
    ${vsd_conn} =  Linux.Connect To Server
                    ...    server_address=localhost
                    ...    server_port=@{vsd_port_forwarding}[0]
                    ...    server_login=root
                    ...    server_password=Alcateldc
                    ...    timeout=30s
    Set Suite Variable    ${vsd_conn}

Revoke existing Util certificate
    # for util
    SSHLibrary.Execute Command
    ...  /opt/vsd/ejbca/deploy/certMgmt.sh -a revoke -u ${util-hostname} -c ${util-hostname} -o csp -d ${util_fqdn}


Generate Util certificate
    # for util
    SSHLibrary.Write
    ...  /opt/vsd/ejbca/deploy/certMgmt.sh -a generate -u ${util-hostname} -c ${util-hostname} -d ${util_fqdn} -f pem -t server -o csp -s root@${util-mgmt_ip}:/opt/proxy/config/keys/

    SSHLibrary.Read Until Regexp
    ...  password:

    SSHLibrary.Write  Alcateldc${\n}


Connect to Util VM and configure metadata file
    ${util_conn} =  Linux.Connect To Server
                      ...    server_address=localhost
                      ...    server_port=@{util_port_forwarding}[0]
                      ...    server_login=root
                      ...    server_password=Alcateldc
                      ...    timeout=30s
    Set Suite Variable    ${util_conn}

    SSHLibrary.Execute Command  ping count 1 ${vsd_fqdn}

    ## Diable Existing TLS
    SSHLibrary.Execute Command  systemctl restart haproxy;
    SSHLibrary.Execute Command  systemctl restart supervisord
    SSHLibrary.Execute Command  ip route add 10.10.0.0/24 via 10.0.0.4
    SSHLibrary.Execute Command  echo "0cd035411256a380d6db5e8bace64f16  ncpeimg_5.2.2_25.tar" > /var/www/html/ncpeimg_5.2.2_25.md5
    SSHLibrary.Execute Command  echo '{"upgradeFile": "http://${util_fqdn}/ncpeimg_5.2.2_25.tar", "upgradeVersion": "5.2.2_25"}'  > /var/www/html/ncpeimg_5.2.2_25.md5


Connect to Portal VM and update login/logout URL
    ${portal_conn} =  Linux.Connect To Server
                      ...    server_address=localhost
                      ...    server_port=@{portal_port_forwarding}[0]
                      ...    server_login=root
                      ...    server_password=Alcateldc
                      ...    timeout=30s
    Set Suite Variable    ${portal_conn}

Update VNS logout and Redirect URL 
    SSHLibrary.Execute Command    sed -i '/vnsportal.redirect.uri=/c vnsportal.redirect.uri=http://${jumpbox_address}:1443/' /opt/vnsportal/tomcat-instance1/application.properties
    SSHLibrary.Execute Command    sed -i '/vns.logout.url=/c vns.logout.url=http://${jumpbox_address}:1443/' /opt/vnsportal/tomcat-instance1/application.properties
    SSHLibrary.Execute Command    /opt/vnsportal/restart.sh