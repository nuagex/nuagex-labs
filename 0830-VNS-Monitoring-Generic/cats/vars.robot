*** Variables ***
# infra variables
${vsd_fqdn}                    vsd01.nuage.lab
${vsc-internet_hostname}       vsc-i
${vsc-i_mgmt_ip}               10.0.0.10

${vsc-i_control_ip}            10.10.0.11
${internet_gw_ip}              10.10.0.1


# basic overlay variables
${org_profile_name}            ORG_PROFILE
${org_name}                    Monitoring
${l3domain_template1_name}     DOMAIN_TEMPLATE
${customer_domain_name}        CUSTOMER
${mv_zone_name}                Mountain View
${ny_zone_name}                New York
${mv_subnet_name}              Mountain View
${ny_subnet_name}              New York
${mv_network_addr}             10.20.0.0/24
${ny_network_addr}             10.40.0.0/24
${sec_policy1_name}            ALLOW_ALL

# VNS variables
${infra_gw_profile_name}       IGW
${infra_access_profile_name}   IAP
${util1_fqdn}                  utility.nuage.lab
${vsc_profile1_name}           VSC-INTERNET
${vsc-i_ctrl_ip}               10.10.0.11
## NSG template names
${nsg_inet_template_name}      INTERNET_NSG
## NSG names
${mv_nsg1_name}                Mountain View
${ny_nsg1_name}                New York
## vports
${mv_nsg1_vport1_name}         MV-VPORT1
${ny_nsg1_vport1_name}         NY-VPORT1
## PCs addresses
${mv_pc1_data_addr}            10.20.0.20
${ny_pc1_data_addr}            10.40.0.40

## NSGs Addresses 
${mv_nsg1_address}             Mountain View, California, USA
${ny_nsg1_address}             New York, USA

##############################
#     CONNECTION PARAMETERS
##############################
${jumpbox_address}                TO_BE_FILLED_BY_A_USER
${vsd_password}                   TO_BE_FILLED_BY_A_USER
${ssh_key_path}                   TO_BE_FILLED_BY_A_USER

# port forwarding variables
@{util_port_forwarding}           45100  10.0.0.33
@{vsd_port_forwarding}            45102  10.0.0.2
@{vsci_port_forwarding}           45103  10.0.0.10
@{portal_port_forwarding}         45109  10.0.0.6
@{br1pc1_port_forwarding}         45107  10.0.0.30
@{mvpc1_port_forwarding}          45110  10.0.0.20
@{pe_internet_port_forwarding}    45105  10.0.0.40

*** Keywords ***
Login NuageX User
    NuageUserMgmt.Login user
    ...    cats_api_url=https://${jumpbox_address}:8443
    ...    cats_username=admin
    ...    cats_password=${vsd_password}
    ...    cats_org_name=csp
