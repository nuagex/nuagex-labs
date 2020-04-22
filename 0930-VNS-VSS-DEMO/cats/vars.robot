*** Variables ***
##############################
#     CONNECTION VARIABLES
##############################
${vsd_ip}                         10.0.0.2
${vsd_password}                   # should be empty
${lab_ip_address}                 # should be empty
${ssh_key_path}                   ~/.ssh/id_rsa
${pe-router}                      10.0.0.50
${vsc_mgmt_ip}                    10.0.0.3
${es_mgmt_ip}                     10.0.0.5
${portal_mgmt_ip}                 10.0.0.6
${util_mgmt_ip}                   10.0.0.33
${hq_pc1_mgmt_addr}               10.0.0.10
${hq_server_mgmt_addr}            10.0.0.11
${pa_pc1_mgmt_addr}               10.0.0.20
${pa_tablet_mgmt_addr}            10.0.0.21
${sj_pc1_mgmt_addr}               10.0.0.30
${sj_mobile_mgmt_addr}            10.0.0.31

##############################
#     OVERLAY VARIABLES
##############################
${org_profile_name}               ION_MTRS_PROFILE
${org_name}                       ION Motors Inc
${l3domain_template_name}         L3_DOMAIN_TEMPLATE
# CORP DOMAIN
${l3domain_name}                  ION_MTRS_CORP
${corp_zone_name}                 CORP_ZONE
${corp_hq_sf_subnet_name}         CORP_HQ_SF
${corp_pa_subnet_name}            CORP_PALO_ALTO
${corp_sj_subnet_name}            CORP_SAN_JOSE
${hq_sf_network_addr}             10.40.1.0/24
${pa_network_addr}                10.40.2.0/24
${sj_network_addr}                10.40.3.0/24
${hq_sf_pc1_data_addr}            10.40.1.10
${pa_pc1_data_addr}               10.40.2.10
${sj_pc1_data_addr}               10.40.3.10
# GUEST DOMAIN
${guest_l3domain_name}            ION_MTRS_GUEST
${guest_wifi_zone_name}           WIFI_ZONE
${public_zone_name}               PUBLIC_ZONE
${guest_hq_subnet_name}           GUEST_HQ_SF
${guest_pa_subnet_name}           GUEST_WIFI_PALO_ALTO
${guest_sj_subnet_name}           GUEST_WIFI_SAN_JOSE
${guest_hq_sf_network_addr}       192.168.10.0/24
${guest_pa_network_addr}          192.168.20.0/24
${guest_sj_network_addr}          192.168.30.0/24
${hq_sf_server_data_addr}         192.168.10.100
${pa_tablet_data_addr}            192.168.20.10
${sj_mobile_data_addr}            192.168.30.10
${corp_policy_name}               corp_ingress
${guest_policy_name}              guest_ingress
${corp_egress_policy_name}        corp_egress
${guest_egress_policy_name}       guest_egress
${pg_hq_name}                     PG_HQ
${pg_pa_name}                     PG_PA
${pg_sj_name}                     PG_SJ
${pg_suspect_name}                PG_SUSPECT

##############################
#     VNS VARIABLES
##############################
${infra_gw_profile_name}          IGP
${util1_fqdn}                     util.nuage.lab
${vsc_profile1_name}              VSC-Profile1
${vsc_profile2_name}              VSC-Profile2
${infra_access_profile_name}      IAP
${nsg_template_name}              NSG-T
${hq_sf_nsg1_name}                HQ-SF-NSG
${pa_nsg1_name}                   PA-NSG
${sj_nsg1_name}                   SJ-NSG
${hq_sf_nsg1_vport1_name}         HQ-SF-VPORT1
${pa_nsg1_vport1_name}            PA-VPORT1
${sj_nsg1_vport1_name}            SJ-VPORT1
${hq_sf_nsg1_vport2_name}         HQ-SF-VPORT2
${pa_nsg1_vport2_name}            PA-VPORT2
${sj_nsg1_vport2_name}            SJ-VPORT2
${hq_sf_nsg1_wan1_ip}             10.10.1.10
${pa_nsg1_wan1_ip}                10.10.2.10
${sj_nsg1_wan1_ip}                10.10.3.10
${hq_sf_nsg1_address}             394 Treat Ave, San Francisco, CA 94110
${pa_nsg1_address}                1925 Embarcadero Rd, Palo Alto, CA 94303
${sj_nsg1_address}                1701 Airport Blvd, San Jose, CA 95110
${perf_monit_name}                Custom Probe
${domain}                         nuage.lab
${pa_wan_network}                 10.10.1.0/24
${sj_wan_network}                 10.10.2.0/24
${hq_sf_wan_network}              10.10.3.0/24
${license_url}                    license_value

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
