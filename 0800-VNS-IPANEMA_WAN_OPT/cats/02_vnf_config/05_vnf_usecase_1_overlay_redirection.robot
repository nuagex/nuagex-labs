*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Variables ***
@{subnets}    ${branch1_subnet_name}  ${branch2_subnet_name}  ${branch3_subnet_name}  ${hq_subnet_name}

*** Test Cases ***
Configuring traffic redirection policies
    [Tags]  FWDPOL

    Begin Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${l3domain_name}

    Create Ingress Forwarding Policy in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    name=VNF INGRESS REDIRECTION
    ...    active=True

    Create Egress Forwarding Policy in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    name=VNF EGRESS REDIRECTION
    ...    active=True

Creating policy entries for HQ VNF
    Create Ingress/Egress Policy Entries for VNF
    ...    vnf_name=${hq_vnf1_name}
    ...    vnf_subnet_name=${hq_subnet_name}
    ...    priority_base=10


Creating policy entries for Branch1 VNF
    Create Ingress/Egress Policy Entries for VNF
    ...    vnf_name=${branch1_vnf1_name}
    ...    vnf_subnet_name=${branch1_subnet_name}
    ...    priority_base=100


Creating policy entries for Branch2 VNF
    Create Ingress/Egress Policy Entries for VNF
    ...    vnf_name=${branch2_vnf1_name}
    ...    vnf_subnet_name=${branch2_subnet_name}
    ...    priority_base=200

Creating policy entries for Branch3 VNF
    Create Ingress/Egress Policy Entries for VNF
    ...    vnf_name=${branch3_vnf1_name}
    ...    vnf_subnet_name=${branch3_subnet_name}
    ...    priority_base=300


Saving policies configuration
    Apply Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${l3domain_name}








*** Keywords ***
Create Ingress/Egress Policy Entries for VNF
    [Arguments]
    ...    ${vnf_name}=${None}
    ...    ${vnf_subnet_name}=${None}
    ...    ${priority_base}=${None}

    Collections.Remove Values From List
    ...    ${subnets}
    ...    ${vnf_subnet_name}

    :FOR  ${index}  ${remote_subnet}  IN ENUMERATE  @{subnets}
    \    ${priority} =  Evaluate    ${priority_base} + ${index}
    \    Create Ingress Forwarding Policy Entry in L3 Domain
         ...    cats_org_name=${org_name}
         ...    cats_domain_name=${l3domain_name}
         ...    ACLTemplateName=VNF INGRESS REDIRECTION
         ...    description=${vnf_name}
         ...    statsLoggingEnabled=True
         ...    action=REDIRECT
         ...    priority=${priority}
         ...    cats_traffic_source=@[subnet, ${vnf_subnet_name}]
         ...    cats_traffic_destination=@[subnet, ${remote_subnet}]
         ...    cats_redirection_target_name=${vnf_name}_LAN

    \    Create Egress Forwarding Policy Entry in L3 Domain
         ...    cats_org_name=${org_name}
         ...    cats_domain_name=${l3domain_name}
         ...    ACLTemplateName=VNF EGRESS REDIRECTION
         ...    description=${vnf_name}
         ...    statsLoggingEnabled=True
         ...    action=REDIRECT
         ...    priority=${priority}
         ...    cats_traffic_source=@[subnet, ${remote_subnet}]
         ...    cats_traffic_destination=@[subnet, ${vnf_subnet_name}]
         ...    cats_redirection_target_name=${vnf_name}_WAN

    Collections.Append To List
    ...    ${subnets}
    ...    ${vnf_subnet_name}