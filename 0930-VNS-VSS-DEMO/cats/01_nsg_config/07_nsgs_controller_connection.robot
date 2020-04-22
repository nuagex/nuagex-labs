*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Library           ./lib/keywords.py
Suite Setup       Login NuageX User

*** Test Cases ***
Ensure HQ NSG is connected to both VSCs
    ${hq_sf_nsg_sysid} =  Get NSG System ID
                       ...    cats_org_name=${org_name}
                       ...    cats_nsg_name=${hq_sf_nsg1_name}

    ${vsc-internet_conn} =  VSC.Login
                            ...  vsc_address=${vsc_mgmt_ip}
                            ...  username=admin
                            ...  password=admin


    ${hq_sf_nsg_wan_ip} =  Get NSG Wan IP from VSC
                        ...    nsg_id=${hq_sf_nsg_sysid}

    ${output} =  NSG.Get NSG Controllers Info
                 ...    nsg_address=${hq_sf_nsg_wan_ip}
                 ...    verbose=True

    Local_lib.NSG Should Have Active Controllers
    ...  controller_info=${output}
    ...  controller_number=1

Ensure MV NSG is connected to both VSCs
    ${pa_nsg_sysid} =  Get NSG System ID
                       ...    cats_org_name=${org_name}
                       ...    cats_nsg_name=${pa_nsg1_name}

    ${vsc-mpls_conn} =  VSC.Login
                        ...  vsc_address=${vsc_mgmt_ip}
                        ...  username=admin
                        ...  password=admin

    ${pa_nsg_wan_ip} =  Get NSG Wan IP from VSC
                        ...    nsg_id=${pa_nsg_sysid}

    ${output} =  NSG.Get NSG Controllers Info
                 ...    nsg_address=${pa_nsg_wan_ip}
                 ...    verbose=True

    Local_lib.NSG Should Have Active Controllers
    ...  controller_info=${output}
    ...  controller_number=1

Ensure NY NSG is connected to both VSCs
    ${sj_nsg_sysid} =  Get NSG System ID
                       ...    cats_org_name=${org_name}
                       ...    cats_nsg_name=${sj_nsg1_name}

    ${vsc-mpls_conn} =  VSC.Login
                        ...  vsc_address=${vsc_mgmt_ip}
                        ...  username=admin
                        ...  password=admin

    ${sj_nsg_wan_ip} =  Get NSG Wan IP from VSC
                        ...    nsg_id=${sj_nsg_sysid}

    ${output} =  NSG.Get NSG Controllers Info
                 ...    nsg_address=${sj_nsg_wan_ip}
                 ...    verbose=True

    Local_lib.NSG Should Have Active Controllers
    ...  controller_info=${output}
    ...  controller_number=1
