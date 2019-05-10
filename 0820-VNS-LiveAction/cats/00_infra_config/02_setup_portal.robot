*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Connect portal vm 
    Linux.Connect To Server With Keys
    ...    server_address=${portal_mgmt_ip}
    ...    username=root
    ...    priv_key=${ssh_key_path}

## update URLs
Update VNS logout and Redirect URL 
    SSHLibrary.Execute Command    sed -i '/vnsportal.redirect.uri=/c vnsportal.redirect.uri=http://${lab_ip_address}:1443/' /opt/vnsportal/tomcat-instance1/application.properties
    SSHLibrary.Execute Command    sed -i '/vns.logout.url=/c vns.logout.url=http://${lab_ip_address}:1443/' /opt/vnsportal/tomcat-instance1/application.properties
    SSHLibrary.Execute Command    /opt/vnsportal/restart.sh