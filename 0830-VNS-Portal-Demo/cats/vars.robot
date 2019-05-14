*** Variables ***
##############################
#     CONNECTION VARIABLES
##############################
${vsd_ip}                         10.0.0.2
${vsd_password}                   # should be empty
${lab_ip_address}                 # should be empty
${ssh_key_path}                   ~/.ssh/id_rsa
${pe-router}                      10.0.0.50
${pe-mpls_mgmt_ip}                10.0.0.220
${vsc-internet_mgmt_ip}           10.0.0.10
${vsc-mpls_mgmt_ip}               10.0.0.20
${vsc-internet_control_ip}        10.10.1.3
${vsc-mpls_control_ip}            10.20.1.3
${vsc-internet_system_ip}         192.168.168.1
${vsc-mpls_system_ip}             192.168.168.2
${portal_mgmt_ip}                 10.0.0.6
${util_mgmt_ip}                   10.0.0.33
${hq_pc1_mgmt_addr}               10.0.0.110
${mv_pc1_mgmt_addr}               10.0.0.120
${ny_pc1_mgmt_addr}               10.0.0.130


##############################
#     OVERLAY VARIABLES
##############################
${org_profile_name}               ORG_PROFILE
${org_name}                       ORG
${l3domain_template_name}         L3_DOMAIN_TEMPLATE
${l3domain_name}                  ORG_DOMAIN
${hq_zone_name}                   HQ_ZONE
${mv_zone_name}                   MV_ZONE
${ny_zone_name}                   NY_ZONE
${hq_subnet_name}                 HQ_SUB
${mv_subnet_name}                 MV_SUB
${ny_subnet_name}                 NY_SUB
${hq_network_addr}                192.168.10.0/24
${mv_network_addr}                192.168.20.0/24
${ny_network_addr}                192.168.30.0/24
${hq_pc1_data_addr}               192.168.10.99
${mv_pc1_data_addr}               192.168.20.99
${ny_pc1_data_addr}               192.168.30.99
${sec_policy_name}                Allow_All_Demo_POLICY

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
${mv_nsg1_name}                   MV-NSG
${ny_nsg1_name}                   NY-NSG
${hq_nsg1_vport1_name}            HQ-VPORT1
${mv_nsg1_vport1_name}            MV-VPORT1
${ny_nsg1_vport1_name}            NY-VPORT1
${hq_nsg1_wan1_ip}                10.10.10.10
${mv_nsg1_wan1_ip}                10.10.20.10
${ny_nsg1_wan1_ip}                10.10.30.10
${hq_nsg1_wan2_ip}                10.20.10.10
${mv_nsg1_wan2_ip}                10.20.20.10
${ny_nsg1_wan2_ip}                10.20.30.10
${hq_nsg1_address}                394 Treat Ave, San Francisco, CA 94110
${mv_nsg1_address}                755 Ravendale Dr, Mountain View, CA
${ny_nsg1_address}                Ozone Park, New York, NY
${perf_monit_name}                Custom Probe


*** Keywords ***
Login NuageX User
    Run Keyword If  $vsd_password == ""
    ...  Get NuageX lab password

    Run Keyword If  $lab_ip_address == ""
    ...  Get NuageX lab ip address

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

Get NuageX lab ip address
    Process.Run Process
    ...  wget -q -O - http://169.254.169.254/2009-04-04/meta-data/public-ipv4
    ...  shell=True
    ...  alias=public_ip_address

    ${lab_ip_address} =  Process.Get Process Result
                       ...  public_ip_address
                       ...  stdout=True

    Set Global Variable  ${lab_ip_address}
