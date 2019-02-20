*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Attach HQ-IPE1 to MANAGEMENT subnet
    Create Bridge vPort for NSG
    ...    name=HQ-IPE1
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}
    ...    cats_domain_type=L3
    ...    cats_subnet_name=${hq-ipe_mgmt_subnet1_name}
    ...    cats_nsg_name=${hq_nsg1_name}
    ...    cats_nsg_port_name=port4-Access
    ...    cats_vlan_id=0

    Create Bridge Interface in L3 Domain
    ...    name=HQ-IPE-MANAGEMENT
    ...    cats_vport_name=HQ-IPE1
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}