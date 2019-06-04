*** Variables ***
# basic overlay variables
${org_profile_name}            ORG_PROFILE
${l3domain_template1_name}     DOMAIN_TEMPLATE
${l3domain_name}               DOMAIN
${zone_name}                   ZONE
${subnet3_name}                BRANCH3
${subnet4_name}                BRANCH4
${subnet5_name}                BRANCH5
${subnet3_network_addr}        172.17.3.0/24
${subnet4_network_addr}        172.17.4.0/24
${subnet5_network_addr}        172.17.5.0/24
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
${nsg3_name}                   PARIS
${nsg4_name}                   HELSINKI
${nsg5_name}                   ANTWERP
${org_name}                    ENTERPRISE2
${vport3_name}                 ACCESS_BRANCH3
${vport4_name}                 ACCESS_BRANCH4
${vport5_name}                 ACCESS_BRANCH5
${branch_pc3_data_addr}        172.17.3.101
${branch_pc4_data_addr}        172.17.4.101
${branch_pc5_data_addr}        172.17.5.101

# port forwarding variables
${ssh_key_path}                TO_BE_FILLED_BY_A_USER
${jumpbox_address}             TO_BE_FILLED_BY_A_USER
@{util_port_forwarding}        45100  10.0.0.33
@{brpc3_port_forwarding}       45103  10.0.0.203
@{brpc4_port_forwarding}       45104  10.0.0.204
@{brpc5_port_forwarding}       45105  10.0.0.205

*** Keywords ***
Login NuageX User
    NuageUserMgmt.Login user
    ...    cats_api_url=https://${jumpbox_address}:8443
    ...    cats_username=admin
    ...    cats_password=TO_BE_FILLED_BY_A_USER
    ...    cats_org_name=csp