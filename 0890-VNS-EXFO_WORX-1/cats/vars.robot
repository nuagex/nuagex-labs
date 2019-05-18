*** Variables ***
##############################
#     CONNECTION VARIABLES
##############################
${es_hostname}                    es
${vsd_ip}                         10.0.0.2
${es_ip}                          10.0.0.5
${vsd_password}                   # should be empty
${ssh_key_path}                   ~/.ssh/id_rsa
${pe-internet_mgmt_ip}            10.0.0.210
${vsc-internet_mgmt_ip}           10.0.0.3
${vsc-internet_control_ip}        10.10.1.3
${vsc-internet_system_ip}         192.168.168.1
${util_mgmt_ip}                   10.0.0.33
${hq_pc1_mgmt_addr}               10.0.0.190
${branch1_pc1_mgmt_addr}          10.0.0.110


##############################
#     OVERLAY VARIABLES
##############################
${org_profile_name}               ORG_PROFILE
${org_name}                       EXFO_INTEGRATION
${l3domain_template1_name}        L3_DOMAIN_TEMPLATE
${l3domain_name}                  L3_DOMAIN
${hq_zone_name}                   HQ_ZONE
${branch1_zone_name}              BRANCH1_ZONE
${branch2_zone_name}              BRANCH2_ZONE
${hq_subnet_name}                 HQ_SUB
${hq_subnet2_name}                HQ_IGW_SUB
${branch1_subnet_name}            BRANCH1_SUB
${branch2_subnet_name}            BRANCH2_SUB
${hq_network_addr}                192.168.90.0/24
${hq_network2_addr}               192.168.91.0/24
${branch1_network_addr}           192.168.10.0/24
${branch2_network_addr}           192.168.20.0/24
${hq_pc1_data_addr}               192.168.90.99
${hq_igw1_data_addr}              192.168.91.199
${hq_igw1_data_gw_addr}           192.168.91.1
${branch1_pc1_data_addr}          192.168.10.99
${branch2_pc1_data_addr}          192.168.20.99
## Policies variables
${sec_policy1_name}               ALLOW_ALL
${3.2_policy_name}                3.2 Simple Policies
${saas_mix1_group_name}           SaaS Mix
${platinum_apm_group_name}        PLATINUM
## QoS variables
${dscp_table1_name}               DSCP_TABLE1
${parent_queue_rate_lim_name}     Parent Queue
${parent_queue_cir}               100
${parent_queue_pir}               100
${egr_qos_policy1_name}           Egress QoS 1

##############################
#     VNS VARIABLES
##############################
${infra_gw_profile_name}          IGP
${util1_fqdn}                     util.nuage.lab
${vsc_profile1_name}              VSC-Profile1
${vsc_profile2_name}              VSC-Profile2
${infra_access_profile_name}      IAP
${nsg_template_name}              NSG-T
${hq_nsg1_name}                   HQ-NSG
${branch1_nsg1_name}              BRANCH1-NSG
${branch2_nsg1_name}              BRANCH2-NSG
${hq_nsg1_vport1_name}            HQ-VPORT1
${hq_nsg1_vport2_name}            HQ-VPORT2
${branch1_nsg1_vport1_name}       BRANCH1-VPORT1
${branch2_nsg1_vport1_name}       BRANCH2-VPORT1

##############################
#     VNF VARIABLES
##############################
${vnf_image_url}
${vnf_image_md5_url}

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
    ...  curl -s http://169.254.169.254/2009-04-04/user-data | grep -m1 "content" | awk '{print $3}' | base64 -d | grep -m1 "password" | awk '{print $2}'
    ...  shell=True
    ...  alias=passwd

    ${vsd_password} =  Process.Get Process Result
                       ...  passwd
                       ...  stdout=True

    Set Global Variable  ${vsd_password}