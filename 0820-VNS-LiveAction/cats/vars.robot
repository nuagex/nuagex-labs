*** Variables ***
# infra variables
${vsd_fqdn}                     vsd01.nuage.lab
${vsc-hostname}                 vsc01admin
${vsc-mgmt_ip}                  10.0.0.3
${util-hostname}                proxy
${util-mgmt_ip}                 10.0.0.3
${util_fqdn}                    utility.nuage.lab

# overlay variables
${org_name}                     Nuage
${org_profile_name}             Advanced_Profile
${l3domain_template_name}       L3 Template
${customer_domain_name}         Nuage L3 Domain
${sac_zone_name}                Sacramento
${edison_zone_name}             Edison
${sac_subnet_name}              Sacramento
${edison_subnet_name}           Edison
${sac_network_addr}             192.168.1.0/24
${sac_subnet_min_address}       192.168.1.100
${sac_subnet_max_address}       192.168.1.200
${edison_network_addr}          192.168.2.0/24
${edison_subnet_min_address}    192.168.2.100
${edison_subnet_max_address}    192.168.2.200
${sec_policy_name}              Allow All

# nsg infra variables
${edison_nsg_name}              Edison
${sac_nsg_name}                 Sacramento
${nsg_inet_template_name}       NSG-V
${infra_gw_profile_name}        Infrastructure Profile
${vsc_profile_name}             VSC Profile
${infra_access_profile_name}    NSG Access Profile
${proxy_user}                   proxy
${nsg_user}                     nuagexuser
${nsg_user_pswd}                nuagexuser
${nsg_username}                 nuagex
${nsg_user_email}               test@nuage.com
${csp_org_name}                 csp

##############################
#    LiveAction PARAMETERS
##############################



##############################
#     CONNECTION PARAMETERS
##############################
${jumpbox_address}                124.252.253.105
${vsd_password}                   4D4ChAnUCs751o9t
${ssh_key_path}                   ~/.ssh/id_rsa

# port forwarding variables
@{vsd_port_forwarding}            45100  10.0.0.2
@{vsc_port_forwarding}            45101  10.0.0.3
@{portal_port_forwarding}         45102  10.0.0.6
@{live_action_port_forwarding}    45103  10.0.0.11
@{util_port_forwarding}           45104  10.0.0.33

@{sac_pc_port_forwarding}         45105  10.0.0.10
@{edison_pc_port_forwarding}      45106  10.0.0.40

${sac_nsg_vport_name}             Sacramento Port
${edison_nsg_vport_name}          Edison Port
*** Keywords ***
Login NuageX User
    NuageUserMgmt.Login user
    ...    cats_api_url=https://${jumpbox_address}:8443
    ...    cats_username=admin
    ...    cats_password=${vsd_password}
    ...    cats_org_name=csp
