*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Delete scenario
    Delete Organization in VSD
    ...    cats_org_name=${org_name}