*** Variables ***
# infra variables
${vsd_fqdn}                    vsd.nuage.lab
${vsd_password}                # should be empty
${lab_ip_address}              # should be empty
${vsd_ip}                      10.21.0.16
${vsc-internet_hostname}       vsc-i
${vsc_control_ip}              10.35.41.21
${vsc_control_dummy_ip}        1.1.1.1

# basic overlay variables
${org_profile_name}            ORG_PROFILE
${org_name}                    Fortinet
${l3domain_template1_name}     DOMAIN_TEMPLATE
${customer_domain_name}        CUSTOMER
${managment_domain_name}       VNF-Managment-Domain
${lan_zone_name}               LANs
${mgmt_zone_name}               LANs
${lan1_subnet_name}            LAN1
${lan2_subnet_name}            LAN2
${mgmt_lan_subnet_name}        MGMT_LAN
${vnf_mgmt_subnet_name}        VNF_MGMT
${lan1_network_addr}           10.35.45.0/24
${lan2_network_addr}           10.35.46.0/24
${mgmt_lan_network_addr}       10.35.47.0/24
${vnf_mgmt_network_addr}       10.40.0.0/24
${sec_policy1_name}            ALLOW_ALL

# VNS variables
${infra_gw_profile_name}       IGW
${infra_access_profile_name}   IAP
${util1_fqdn}                  util.lab.local
${vsc_profile1_name}           VSC-INTERNET
${vsc_dummy_profile_name}      VSC-INTERNET-DUMMY
## NSG template names
${nsg_inet_template_name}      INTERNET_NSG
## NSG names
${hq_nsg1_name}                NSG-X-02
## vports
${lan1_nsg1_vport1_name}       LAN1-VPORT1
${lan2_nsg1_vport1_name}       LAN2-VPORT1
${mgmt_lan_nsg1_vport1_name}   MGMT_LAN-VPORT1
## PCs addresses
${lan1_pc1_data_addr}          10.35.45.10
${lan2_pc1_data_addr}          10.35.46.10
${mgmt_lan_pc1_data_addr}      10.35.47.10
${vnf_mem_size}                6656
##############################
#  VNF MGMT DOMAIN PARAMETERS
##############################
${fortinet_vnf_name}                Fortinet-VNF

##############################
#     CONNECTION PARAMETERS
##############################
*** Keywords ***
Login NuageX User
    NuageUserMgmt.Login user
    ...    cats_api_url=https://${vsd_ip}:8443
    ...    cats_username=csproot
    ...    cats_password=csproot
    ...    cats_org_name=csp
