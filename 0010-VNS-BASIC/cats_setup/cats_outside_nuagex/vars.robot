*** Variables ***
# basic overlay variables
${org_profile_name}            ORG_PROFILE
${l3domain_template1_name}     DOMAIN_TEMPLATE
${l3domain_name}               DOMAIN
${zone_name}                   ZONE
${subnet1_name}                SUBNET1
${subnet2_name}                SUBNET2
${subnet1_network_addr}        192.168.1.0/24
${subnet2_network_addr}        192.168.2.0/24
${sec_policy1_name}            ALLOW_ALL

# VNS variables
${infra_gw_profile_name}       IGW
${util1_fqdn}                  utility.nuage.lab
${vsc_profile1_name}           VSCPROF1
${vsc1_ip}                     10.0.0.3
${nsg_template_name}           NSG_TEMPLATE
${infra_access_profile_name}   IAP
${nsg1_name}                   NSG_1
${nsg2_name}                   NSG_2
${org_name}                    NUAGEX
${vport1_name}                 VPORT1
${vport2_name}                 VPORT2
${branch_pc1_data_addr}        192.168.1.101
${branch_pc2_data_addr}        192.168.2.102

# port forwarding variables
${ssh_key_path}                ~/.ssh/cats
${jumpbox_address}             124.252.253.61
@{util_port_forwarding}        45100  10.0.0.33
@{brpc1_port_forwarding}       45101  10.0.0.101
@{brpc2_port_forwarding}       45102  10.0.0.102

*** Keywords ***
Login NuageX User
    NuageUserMgmt.Login user
    ...    cats_api_url=https://${jumpbox_address}:8443
    ...    cats_username=admin
    ...    cats_password=oaDt4fmiVUSlQHvJ
    ...    cats_org_name=csp