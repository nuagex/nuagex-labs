*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Creating Redirection Targets and vPorts for Branch1 VNF
    Create Redirection Targets With VPorts for VNF
    ...    org_name=${org_name}
    ...    domain_name=${l3domain_name}
    ...    vnf_name=${branch1_vnf1_name}
    ...    segmentation_id=1

Creating Redirection Targets and vPorts for Branch2 VNF
    Create Redirection Targets With VPorts for VNF
    ...    org_name=${org_name}
    ...    domain_name=${l3domain_name}
    ...    vnf_name=${branch2_vnf1_name}
    ...    segmentation_id=2

Creating Redirection Targets and vPorts for Branch3 VNF
    Create Redirection Targets With VPorts for VNF
    ...    org_name=${org_name}
    ...    domain_name=${l3domain_name}
    ...    vnf_name=${branch3_vnf1_name}
    ...    segmentation_id=3











*** Keywords ***
Create Redirection Targets With VPorts for VNF
    [Arguments]
    ...    ${org_name}=${None}
    ...    ${domain_name}=${None}
    ...    ${vnf_name}=${None}
    ...    ${segmentation_id}=${None}

    Create Redirection Target in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${domain_name}
    ...    name=${vnf_name}_LAN
    ...    endPointType=NSG_VNF

    Create Redirection Target in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${domain_name}
    ...    name=${vnf_name}_WAN
    ...    endPointType=NSG_VNF

    ${full_vport_name} =  Set Variable    ${vnf_name}-LAN-${domain_name}
    ${normalized_vport_name} =  String.Get Substring
                                ...    ${full_vport_name}
                                ...    start=0
                                ...    end=34

    Add vPort to Redirection Target in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${domain_name}
    ...    cats_vport_name=${normalized_vport_name}-${segmentation_id}
    ...    cats_redirection_target_name=${vnf_name}_LAN

    ${full_vport_name} =  Set Variable    ${vnf_name}-WAN-${domain_name}
    ${normalized_vport_name} =  String.Get Substring
                                ...    ${full_vport_name}
                                ...    start=0
                                ...    end=34

    Add vPort to Redirection Target in L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${domain_name}
    ...    cats_vport_name=${normalized_vport_name}-${segmentation_id}
    ...    cats_redirection_target_name=${vnf_name}_WAN
