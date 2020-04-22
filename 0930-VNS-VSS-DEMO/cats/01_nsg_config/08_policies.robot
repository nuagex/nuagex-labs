*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Download policies script
    ${rc}=   OperatingSystem.Run and Return RC  curl http://files.nuagedemos.net/policies.pex -L -O
    Should Be Equal As Integers  ${rc}  0

Change permissions
    ${rc}=  OperatingSystem.Run and Return RC  chmod +x ./policies.pex
    Should Be Equal As Integers  ${rc}  0

Create policies and TCA configuration
    ${rc}=  OperatingSystem.Run and Return RC  ./policies.pex
    Should Be Equal As Integers  ${rc}  0