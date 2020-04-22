*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot

*** Test Cases ***
Download policies script
    OperatingSystem.Run  curl http://files.nuagedemos.net/policies.pex -L -O

Change permissions
    OperatingSystem.Run  chmod +x ./policies.pex

Create policies and TCA configuration
    OperatingSystem.Run  ./policies.pex
