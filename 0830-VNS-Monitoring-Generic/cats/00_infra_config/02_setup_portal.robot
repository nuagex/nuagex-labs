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

    # port forwarding to access Portal VM
    SSHLibrary.Create Local SSH Tunnel
    ...  local_port=@{portal_port_forwarding}[0]
    ...  remote_host=@{portal_port_forwarding}[1]
    ...  remote_port=22

## connect to portal vm and update login and logout URL
Connect to Portal VM and update login/logout URL
    ${portal_conn} =  Linux.Connect To Server
                      ...    server_address=localhost
                      ...    server_port=@{portal_port_forwarding}[0]
                      ...    server_login=root
                      ...    server_password=Alcateldc
                      ...    timeout=30s
    Set Suite Variable    ${portal_conn}

## update URLs
Update VNS logout and Redirect URL 
    SSHLibrary.Execute Command    sed -i '/vnsportal.redirect.uri=/c vnsportal.redirect.uri=http://${jumpbox_address}:1443/' /opt/vnsportal/tomcat-instance1/application.properties
    SSHLibrary.Execute Command    sed -i '/vns.logout.url=/c vns.logout.url=http://${jumpbox_address}:1443/' /opt/vnsportal/tomcat-instance1/application.properties
    SSHLibrary.Execute Command    /opt/vnsportal/restart.sh