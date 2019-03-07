*** Variables ***
##############################
#     OVERLAY VARIABLES
##############################
${org_profile_name}            BASIC-VNS-1
${org_name}                    PEPSI CORP
${l3domain_template1_name}     EMPTY
${l3domain_name}               WHOLESALE
${zone_name}                   BRANCHES
${subnet1_name}                BRANCH_1
${subnet2_name}                BRANCH_2
${subnet1_network_addr}        192.168.1.0/24
${subnet2_network_addr}        192.168.2.0/24
${sec_policy1_name}            ALLOW_ALL

##############################
#     VNS VARIABLES
##############################
${infra_gw_profile_name}       PEPSI PROFILE
${util_mgmt_addr}              10.0.0.33
${util1_fqdn}                  utility.nuage.lab
${vsc_profile1_name}           PEPSI VSC PROFILE
${vsc1_ip}                     10.0.0.3
${nsg_template_name}           TEMPLATE_1
${infra_access_profile_name}   IAP_1
${nsg1_name}                   NSG_1
${nsg2_name}                   NSG_2
${vport1_name}                 VPORT1
${vport2_name}                 VPORT2
${branch_pc1_mgmt_addr}        10.0.0.101
${branch_pc1_data_addr}        192.168.1.101
${branch_pc2_mgmt_addr}        10.0.0.102
${branch_pc2_data_addr}        192.168.2.102

##############################
#     CONNECTION PARAMETERS
##############################
${vsd_password}                   # TO_BE_FILLED_BY_A_USER: LAB_PASSWORD
${ssh_key_path}                   ~/.ssh/id_rsa
${vsd_ip}                         10.0.0.2

*** Keywords ***
Login NuageX User
    NuageUserMgmt.Login user
    ...    cats_api_url=https://${vsd_ip}:8443
    ...    cats_username=admin
    ...    cats_password=${vsd_password}
    ...    cats_org_name=csp