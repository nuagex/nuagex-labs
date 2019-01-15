*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Configuring Security Policies for VNF Infrastructure domain
    [Tags]   ACL

    Begin Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=VNF Infrastructure domain

    Create Ingress Security Policy in L3 Domain
    ...    name=${sec_policy1_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=VNF Infrastructure domain
    ...    allowAddressSpoof=True
    ...    defaultAllowIP=True
    ...    defaultAllowNonIP=True

    Create Egress Security Policy in L3 Domain
    ...    name=${sec_policy1_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=VNF Infrastructure domain
    ...    defaultAllowIP=True
    ...    defaultAllowNonIP=True

    Apply Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=VNF Infrastructure domain
