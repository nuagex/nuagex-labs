*** Variables ***
# infra variables
${vsd_fqdn}                    vsd.nuage.lab
${vsc-internet_hostname}       vsc-i
${vsc-i_mgmt_ip}               10.0.0.10

${vsc-i_control_ip}            10.10.90.20
${pe_internet_mgmt_ip}         10.0.0.210
${hq_internet_gw_ip}           10.10.90.1
${util_mgmt_addr}              10.0.0.33

# basic overlay variables
${org_profile_name}            ORG_PROFILE
${org_name}                    EXFO
${l3domain_template1_name}     DOMAIN_TEMPLATE
${customer_domain_name}        CUSTOMER
${hq_zone_name}                HQ
${branch1_zone_name}           BRANCH1
${hq_subnet_name}              HQ_SUB1
${branch1_subnet_name}         BRANCH1_SUB1
${branch1_test_subnet_name}    BRANCH1_TEST_SUB
${hq_network_addr}             192.168.90.0/24
${branch1_network_addr}        192.168.10.0/24
${branch1_test_network_addr}   192.168.30.0/24
${sec_policy1_name}            ALLOW_ALL

# VNS variables
${infra_gw_profile_name}       IGW
${infra_access_profile_name}   IAP
${util1_fqdn}                  util.nuage.lab
${vsc_profile1_name}           VSC-INTERNET
${vsc-i_ctrl_ip}               10.10.90.20
## NSG template names
${nsg_inet_branch_template_name}  INTERNET_NSG_BRANCH
${nsg_inet_hq_template_name}      INTERNET_NSG_HQ
## NSG names
${hq_nsg1_name}                HQ-NSG1
${branch1_nsg1_name}           BRANCH1-NSG1
## vports
${hq_nsg1_vport1_name}         HQ-NSG1-VPORT1
${branch1_nsg1_vport1_name}    BRANCH1-NSG1-VPORT1
${branch1_nsg1_vport2_name}    BRANCH1-NSG1-VPORT2
## PCs addresses
${hq_pc1_mgmt_addr}            10.0.0.190
${hq_pc1_data_addr}            192.168.90.2
${branch1_pc1_mgmt_addr}       10.0.0.110
${branch1_pc1_data_addr}       192.168.10.2
${branch1_testpc_data_addr}    192.168.30.2

##############################
#  VNF MGMT DOMAIN PARAMETERS
##############################
${vnf_mgmt_domain_name}                VNF MANAGEMENT
${vnf_mgmt_subnet1_name}               ${branch1_vnf1_name}
${vnf_mgmt_subnet1_network_addr}       10.100.10.0/24

${vnf_mgmt_subnet4_name}               ${hq_vnf1_name}
${vnf_mgmt_subnet4_network_addr}       10.100.20.0/24

${vnf_mgmt_ems_subnet_name}            BRANCH1_EMS_SUB
${vnf_mgmt_ems_subnet_network_addr}    192.168.20.0/24
${ems_pc_data_addr}                    192.168.20.2

##############################
#     NSG VNF PARAMETERS
##############################
${vnf_mem_size}                   2048
${branch1_vnf1_name}              # TO_BE_FILLED_BY_A_USER: This is set when you create VVerifier on EXFO WORX. eg: branch1
${hq_vnf1_name}                   # TO_BE_FILLED_BY_A_USER: This is set when you create VVerifier on EXFO WORX. eg: hq1
${nas_vnf_image_url}              # TO_BE_FILLED_BY_A_USER: GET_PATH_TO_THE_IMAGE_FROM_NUAGEX_REPRESENTATIVE (rename the image img.qcow2)
${nas_vnf_image_md5_url}          # TO_BE_FILLED_BY_A_USER: GET_PATH_TO_THE_IMAGE_FROM_NUAGEX_REPRESENTATIVE (rename the file img.qcow2.md5)
${vnf_image_url}                  http://${util1_fqdn}/netrounds-test-agent_2.27.0.8.qcow2


##############################
#     VIAVI PARAMETERS
##############################
${branch1_vnf1_boot_iso_url}      # TO_BE_FILLED_BY_A_USER: FILE NAME SHOULD BE {branch1_vnf1_name}.iso(Line 67/68). Example branch1.iso
${hq_vnf1_boot_iso_url}           # TO_BE_FILLED_BY_A_USER: FILE NAME SHOULD BE {branch1_vnf1_name}.iso(Line 67/68). Example hq1.iso


##############################
#     CONNECTION PARAMETERS
##############################
${vsd_password}                   #should be empty
${ssh_key_path}                   ~/.ssh/id_rsa
${vsd_ip}                         10.0.0.2

*** Keywords ***
Login NuageX User
    Run Keyword If  $vsd_password == ""
    ...  Get NuageX lab password

    NuageUserMgmt.Login user
    ...    cats_api_url=https://${vsd_ip}:8443
    ...    cats_username=admin
    ...    cats_password=${vsd_password}
    ...    cats_org_name=csp

Get NuageX lab password
    Process.Run Process
    ...  wget -q -O - http://169.254.169.254/2009-04-04/user-data | grep -m1 "content" | awk '{print $3}' | base64 -d | grep -m1 "password" | awk '{print $2}'
    ...  shell=True
    ...  alias=passwd

    ${vsd_password} =  Process.Get Process Result
                       ...  passwd
                       ...  stdout=True

    Set Global Variable  ${vsd_password}