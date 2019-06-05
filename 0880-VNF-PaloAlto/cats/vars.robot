*** Variables ***
# infra variables
${vsd_fqdn}                    vsd01.nuage.lab
${vsc-internet_hostname}       vsc-i
${vsc-i_mgmt_ip}               10.0.0.10

${vsc_control_ip}              10.0.0.3
${vsc_control_dummy_ip}        1.1.1.1

${vsc-i_control_ip}            10.10.0.11
${hq_internet_gw_ip}           10.10.0.1


# basic overlay variables
${org_profile_name}            ORG_PROFILE
${org_name}                    PAN
${l3domain_template1_name}     DOMAIN_TEMPLATE
${customer_domain_name}        CUSTOMER
${lan_zone_name}               LANs
${lan1_subnet_name}            LAN1
${lan2_subnet_name}            LAN2
${mgmt_lan_subnet_name}        MGMT_LAN
${vnf_mgmt_subnet_name}        VNF_MGMT
${lan1_network_addr}           10.10.0.0/24
${lan2_network_addr}           10.20.0.0/24
${mgmt_lan_network_addr}       10.30.0.0/24
${vnf_mgmt_network_addr}       10.40.0.0/24
${sec_policy1_name}            ALLOW_ALL

# VNS variables
${infra_gw_profile_name}       IGW
${infra_access_profile_name}   IAP
${util1_fqdn}                  utility.nuage.lab
${vsc_profile1_name}           VSC-INTERNET
${vsc_dummy_profile_name}      VSC-INTERNET-DUMMY
${vsc-i_ctrl_ip}               10.10.0.11
## NSG template names
${nsg_inet_template_name}      INTERNET_NSG
## NSG names
${hq_nsg1_name}                NSG-X-01
## vports
${lan1_nsg1_vport1_name}       LAN1-VPORT1
${lan2_nsg1_vport1_name}       LAN2-VPORT1
${mgmt_lan_nsg1_vport1_name}   MGMT_LAN-VPORT1
## PCs addresses
${lan1_pc1_data_addr}          10.10.0.20
${lan2_pc1_data_addr}          10.20.0.20
${mgmt_lan_pc1_data_addr}      10.30.0.30

${vnf_mem_size}                6656
##############################
#  VNF MGMT DOMAIN PARAMETERS
##############################


${pan_vnf_name}                   PAN-VNF
##############################
#     CONNECTION PARAMETERS
##############################
${jumpbox_address}                124.252.253.91
${vsd_password}                   jb_GVPhD_KRan2XB
${ssh_key_path}                   ~/.ssh/id_rsa

# port forwarding variables
@{vsd_port_forwarding}            45102  10.0.0.2
@{portal_port_forwarding}         45103  10.0.0.6
@{vsci_port_forwarding}           45104  10.0.0.10
@{live_action_port_forwarding}    45105  10.0.0.11
@{hqpc1_port_forwarding}          45106  10.0.0.20
@{br1pc1_port_forwarding}         45107  10.0.0.30
@{util_port_forwarding}           45108  10.0.0.33
@{pe_internet_port_forwarding}    45109  10.0.0.40

${livesp_install_url}             http://files.nuagedemos.net/ncpeimg_5.3.2_28.md5

*** Keywords ***
Login NuageX User
    NuageUserMgmt.Login user
    ...    cats_api_url=https://${jumpbox_address}:8443
    ...    cats_username=admin
    ...    cats_password=${vsd_password}
    ...    cats_org_name=csp
