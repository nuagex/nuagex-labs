*** Variables ***
# basic overlay variables
${org_profile_name}            ORG_PROFILE
${l3domain_template1_name}     DOMAIN_TEMPLATE
${l3domain_name}               DOMAIN
${zone_name}                   ZONE
${subnet1_name}                BRANCH1
${subnet2_name}                BRANCH2
${subnet1_network_addr}        172.17.1.0/24
${subnet2_network_addr}        172.17.2.0/24
${sec_policy1_name}            ALLOW_ALL

# VNS variables
${infra_gw_profile_name}       IGW
${util1_fqdn}                  utility.nuage.lab
${vsc_profile1_name}           VSCPROF_INTERNET
${vsc_profile2_name}           VSCPROF_MPLS
${vsc1_ip}                     10.1.255.3
${vsc2_ip}                     10.2.255.3
${nsg_template_name}           NSG_TEMPLATE_NUX
${infra_access_profile_name}   IAP
${nsg1_name}                   MOUNTAIN_VIEW
${nsg2_name}                   NEW_YORK
${org_name}                    ENTERPRISE1
${vport1_name}                 ACCESS_BRANCH1
${vport2_name}                 ACCESS_BRANCH2
${branch_pc1_data_addr}        172.17.1.101
${branch_pc2_data_addr}        172.17.2.101

# port forwarding variables
${ssh_key_path}                TO_BE_FILLED_BY_A_USER
${jumpbox_address}             TO_BE_FILLED_BY_A_USER
@{util_port_forwarding}        46100  10.0.0.33
@{brpc1_port_forwarding}       46101  10.0.0.201
@{brpc2_port_forwarding}       46102  10.0.0.202

*** Keywords ***
Login NuageX User
    NuageUserMgmt.Login user
    ...    cats_api_url=https://${jumpbox_address}:8443
    ...    cats_username=admin
    ...    cats_password=TO_BE_FILLED_BY_A_USER
    ...    cats_org_name=csp
