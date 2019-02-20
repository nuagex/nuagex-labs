*** Variables ***
# infra variables
${vsd_fqdn}                    vsd01.nuage.lab
${util_mgmt_ip}                10.0.0.33
${vsc-internet_hostname}       vsc-i
${vsc-i_mgmt_ip}               10.0.0.10
${vsc-i_control_ip}            10.10.99.10
${hq_internet_gw_ip}           10.10.99.1
${pe_internet_mgmt_ip}         10.0.0.210


# basic overlay variables
${org_profile_name}            ORG_PROFILE
${org_name}                    INFOVISTA
${l3domain_template1_name}     DOMAIN_TEMPLATE
${l3domain_name}               CUSTOMER
${hq_zone_name}                HQ
${branch1_zone_name}           BRANCH1
${branch2_zone_name}           BRANCH2
${branch3_zone_name}           BRANCH3
${hq_subnet_name}              HQ_SUB1
${branch1_subnet_name}         BRANCH1_SUB1
${branch2_subnet_name}         BRANCH2_SUB1
${branch3_subnet_name}         BRANCH3_SUB1
${hq_network_addr}             192.168.99.0/24
${branch1_network_addr}        192.168.1.0/24
${branch2_network_addr}        192.168.2.0/24
${branch3_network_addr}        192.168.3.0/24
${sec_policy1_name}            ALLOW_ALL

# VNS variables
${infra_gw_profile_name}       IGW
${infra_access_profile_name}   IAP
${util1_fqdn}                  utility.nuage.lab
${vsc_profile1_name}           VSC-INTERNET
${vsc-i_ctrl_ip}               10.10.99.10
## NSG template names
${nsg_ubr_template_name}       UBR
${nsg_inet_template_name}      INTERNET_NSG
## NSG names
${hq_nsg1_name}                HQ-NSG1
${branch1_nsg1_name}           BRANCH1-NSG1
${branch2_nsg1_name}           BRANCH2-NSG1
${branch3_nsg1_name}           BRANCH3-NSG1
## vports
${hq_nsg1_vport1_name}         HQ-NSG1-VPORT1
${branch1_nsg1_vport1_name}    BRANCH1-NSG1-VPORT1
${branch2_nsg1_vport1_name}    BRANCH2-NSG1-VPORT1
${branch3_nsg1_vport1_name}    BRANCH3-NSG1-VPORT1
## PCs addresses
${hq_pc1_data_addr}            192.168.99.101
${branch1_pc1_data_addr}       192.168.1.101
${branch2_pc1_data_addr}       192.168.2.102
${branch3_pc1_data_addr}       192.168.3.103

######################################
#  VNF AND IPE MGMT DOMAIN PARAMETERS
######################################
${vnf_mgmt_domain_name}             IPANEMA MANAGEMENT
${vnf_mgmt_subnet1_name}            ${branch1_vnf1_name}
${vnf_mgmt_subnet1_network_addr}    10.100.1.0/24

${vnf_mgmt_subnet2_name}            ${branch2_vnf1_name}
${vnf_mgmt_subnet2_network_addr}    10.100.2.0/24

${vnf_mgmt_subnet3_name}            ${branch3_vnf1_name}
${vnf_mgmt_subnet3_network_addr}    10.100.3.0/24

${branch1_vnf_mgmt_addr}            10.100.1.11
${branch2_vnf_mgmt_addr}            10.100.2.12
${branch3_vnf_mgmt_addr}            10.100.3.13
# IPE config
${hq-ipe_mgmt_subnet1_network_addr}  10.100.99.0/24
${hq-ipe_mgmt_subnet1_name}          HQ-IPE MANAGEMENT

${vnf_mgmt_ems_subnet_name}            EMS-PC
${vnf_mgmt_ems_subnet_network_addr}    10.100.4.0/24
${ems_pc_data_addr}                    10.100.4.10

##############################
#     NSG VNF PARAMETERS
##############################
${vnf_mem_size}                   2048
${branch1_vnf1_name}              BRANCH_1_VIPE
${branch2_vnf1_name}              BRANCH_2_VIPE
${branch3_vnf1_name}              BRANCH_3_VIPE
${hq_vnf1_name}                   HQ_VIPE
${nas_vnf_image_uri}              #TO_BE_FILLED_BY_A_USER:GET_PATH_TO_THE_IMAGE_FROM_NUAGEX_ADMIN
${nas_vnf_image_md5_uri}          #TO_BE_FILLED_BY_A_USER:GET_PATH_TO_THE_IMAGE_MD5_FROM_NUAGEX_ADMIN
${vnf_image_url}                  http://${util1_fqdn}/img.qcow2


##############################
#     SALSA PARAMETERS
##############################
${salsa_ip}                    # TO_BE_FILLED_BY_A_USER:SALSA_IP_ADDRESS
${salsa_url}                   https://${salsa_ip}:8443
${salsa_domain}                # TO_BE_FILLED_BY_A_USER

##############################
#     CONNECTION PARAMETERS
##############################
${jumpbox_address}               # TO_BE_FILLED_BY_A_USER:LAB_IP_ADDRESS
${vsd_password}                  # TO_BE_FILLED_BY_A_USER:VSD_PASSWORD
${ssh_key_path}                  ~/.ssh/id_rsa


*** Keywords ***
Login NuageX User
    NuageUserMgmt.Login user
    ...    cats_api_url=https://${jumpbox_address}:8443
    ...    cats_username=admin
    ...    cats_password=${vsd_password}
    ...    cats_org_name=csp