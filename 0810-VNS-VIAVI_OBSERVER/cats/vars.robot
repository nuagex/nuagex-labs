*** Variables ***
# infra variables
${vsd_fqdn}                    vsd01.nuage.lab
${vsc-internet_hostname}       vsc-i
${vsc-i_mgmt_ip}               10.0.0.10

${vsc-i_control_ip}            10.10.99.10
${pe_internet_mgmt_ip}         10.0.0.210
${hq_internet_gw_ip}           10.10.99.1
${util_mgmt_addr}              10.0.0.33

# basic overlay variables
${org_profile_name}            ORG_PROFILE
${org_name}                    VIAVI
${l3domain_template1_name}     DOMAIN_TEMPLATE
${customer_domain_name}        CUSTOMER
${hq_zone_name}                HQ
${branch1_zone_name}           BRANCH1
${hq_subnet_name}              HQ_SUB1
${branch1_subnet_name}         BRANCH1_SUB1
${branch1_test_subnet_name}    BRANCH1_TEST_SUB
${hq_network_addr}             192.168.99.0/24
${branch1_network_addr}        192.168.1.0/24
${branch1_test_network_addr}   192.168.10.0/24
${sec_policy1_name}            ALLOW_ALL

# VNS variables
${infra_gw_profile_name}       IGW
${infra_access_profile_name}   IAP
${util1_fqdn}                  utility.nuage.lab
${vsc_profile1_name}           VSC-INTERNET
${vsc-i_ctrl_ip}               10.10.99.10
## NSG template names
${nsg_inet_template_name}      INTERNET_NSG
## NSG names
${hq_nsg1_name}                HQ-NSG1
${branch1_nsg1_name}           BRANCH1-NSG1
## vports
${hq_nsg1_vport1_name}         HQ-NSG1-VPORT1
${branch1_nsg1_vport1_name}    BRANCH1-NSG1-VPORT1
${branch1_nsg1_vport2_name}    BRANCH1-NSG1-VPORT2
## PCs addresses
${hq_pc1_mgmt_addr}            10.0.0.199
${hq_pc1_data_addr}            192.168.99.101
${branch1_pc1_mgmt_addr}       10.0.0.101
${branch1_pc1_data_addr}       192.168.1.101
${branch1_testpc_data_addr}    192.168.10.110

##############################
#  VNF MGMT DOMAIN PARAMETERS
##############################
${vnf_mgmt_domain_name}                VNF MANAGEMENT
${vnf_mgmt_subnet1_name}               ${branch1_vnf1_name}
${vnf_mgmt_subnet1_network_addr}       10.100.1.0/24

${vnf_mgmt_subnet4_name}               ${hq_vnf1_name}
${vnf_mgmt_subnet4_network_addr}       10.100.99.0/24

${vnf_mgmt_ems_subnet_name}            BRANCH1_EMS_SUB
${vnf_mgmt_ems_subnet_network_addr}    10.100.4.0/24
${ems_pc_data_addr}                    10.100.4.10

##############################
#     NSG VNF PARAMETERS
##############################
${vnf_mem_size}                   2048
${branch1_vnf1_name}              va_nuage_1  #TO_BE_FILLED_BY_A_USER: GET_FROM_OBSERVERLIVE_WEB_APP
${hq_vnf1_name}                   va_nuage_2  #TO_BE_FILLED_BY_A_USER: GET_FROM_OBSERVERLIVE_WEB_APP
${nas_vnf_image_url}              http://files.nuagedemos.net/viauyeakxhytqqqikgvi/img.qcow2  #TO_BE_FILLED_BY_A_USER: GET_PATH_TO_THE_IMAGE_FROM_NUAGEX_REPRESENTATIVE
${nas_vnf_image_md5_url}          http://files.nuagedemos.net/viauyeakxhytqqqikgvi/img.qcow2.md5  #TO_BE_FILLED_BY_A_USER: GET_PATH_TO_THE_IMAGE_MD5_FROM_NUAGEX_REPRESENTATIVE
${vnf_image_url}                  http://${util1_fqdn}/img.qcow2


##############################
#     VIAVI PARAMETERS
##############################
${branch1_vnf1_boot_iso_url}      https://cloudsights3-demo.s3.amazonaws.com/agent_builder/output/AWkn4QfbdKhp7ZAearMe/va_nuage_1.iso  #TO_BE_FILLED_BY_A_USER: GET_FROM_OBSERVERLIVE_WEB_APP
${hq_vnf1_boot_iso_url}           https://cloudsights3-demo.s3.amazonaws.com/agent_builder/output/AWkn4dZCdKhp7ZAearMf/va_nuage_2.iso  #TO_BE_FILLED_BY_A_USER: GET_FROM_OBSERVERLIVE_WEB_APP

##############################
#     CONNECTION PARAMETERS
##############################
${vsd_password}                   nEFet6rUp_COr7nT  #TO_BE_FILLED_BY_A_USER: LAB_PASSWORD
${ssh_key_path}                   ~/.ssh/id_rsa
${vsd_ip}                         10.0.0.2

*** Keywords ***
Login NuageX User
    NuageUserMgmt.Login user
    ...    cats_api_url=https://${vsd_ip}:8443
    ...    cats_username=admin
    ...    cats_password=${vsd_password}
    ...    cats_org_name=csp
