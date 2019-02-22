*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Create new application
    Create Application
    ...    cats_org_name=${org_name} 
    ...    name=APP_NAME
    ...    preClassificationPath=DEFAULT
    ...    protocol=TCP
    ...    sourceIP=192.168.16.1
    ...    sourcePort=2001
    ...    destinationIP=172.168.16.1
    ...    destinationPort=3001
    ...    etherType=0x0800
    ...    enablePPS=False
    ...    DSCP=2
