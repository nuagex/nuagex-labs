*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Setting up connection to UtilVM
    [Tags]  SOLO-RUN CATS-OUTSIDE

    # create local SSH port forwarding for UtilVM
    Linux.Connect To Server With Keys
    ...    server_address=${jumpbox_address}
    ...    username=admin
    ...    priv_key=${ssh_key_path}

    # port forwarding to access util VM
    SSHLibrary.Create Local SSH Tunnel
    ...    local_port=@{util_port_forwarding}[0]
    ...    remote_host=@{util_port_forwarding}[1]
    ...    remote_port=22

    ${util_mgmt_addr} =  Set Variable    localhost
    ${util_mgmt_port} =  Set Variable    @{util_port_forwarding}[0]

    ${util_conn} =  Linux.Connect To Server
                    ...    server_address=${util_mgmt_addr}
                    ...    server_port=${util_mgmt_port}
                    ...    server_login=root
                    ...    server_password=Alcateldc

    Set Global Variable    ${util_conn}

Downloading VNF files to UtilVM and installing mkisofs utility
    [Tags]    VNF_DOWNLOAD  ONETIME

    SSHLibrary.Switch Connection    ${util_conn}

    # download qcow2 and md5 files and verify integrity
    SSHLibrary.Execute Command
    ...    cd /var/www/html && curl -O ${nas_vnf_image_uri} && curl -O ${nas_vnf_image_md5_uri} && md5sum -c img.qcow2.md5

    # mkisofs is used to create boot.iso files for VNFs
    SSHLibrary.Execute Command
    ...    yum -y install mkisofs

Getting the md5sums for VNF disk image
    ${image_md5} =  SSHLibrary.Execute Command
                    ...    cat /var/www/html/img.qcow2.md5 | awk '{print $1}'

    Set Suite Variable    ${image_md5}

Creating VNF for Branch1
    ${status}  ${branch1_vnf_state} =  Run Keyword And Ignore Error
                                       ...    NuageVNF.Get VNF
                                              ...    name=${branch1_vnf1_name}
                                              ...    cats_org_name=${org_name}


    # if vnf is created and its status is not RUNNING -> go thru the configuration steps
    ${branch1_vnf_state} =  Run Keyword If  $status == 'FAIL' or ($branch1_vnf_state.status != 'RUNNING')
        # user-defined kw, chech the keywords section in the end of this file
        ...    Create VNF And Attach Mgmt Interface
               ...    org_name=${org_name}
               ...    vnf_image_url=${vnf_image_url}
               ...    image_md5=${image_md5}
               ...    vnf_iso_url=http://${util1_fqdn}/${branch1_vnf1_name}.iso
               ...    vnf_name=${branch1_vnf1_name}
               ...    vnf_mem_size=${vnf_mem_size}
               ...    nsg_name=${branch1_nsg1_name}
               ...    segmentation_id=1

    Set Suite Variable     ${branch1_vnf_state}

Creating VNF for Branch2
    ${status}  ${branch2_vnf_state} =  Run Keyword And Ignore Error
                                       ...    NuageVNF.Get VNF
                                              ...    name=${branch2_vnf1_name}
                                              ...    cats_org_name=${org_name}

    # if vnf is created and its status is not RUNNING -> go thru the configuration steps
    ${branch2_vnf_state} =  Run Keyword If  $status == 'FAIL' or ($branch2_vnf_state.status != 'RUNNING')
        # user-defined kw, chech the keywords section in the end of this file
        ...    Create VNF And Attach Mgmt Interface
               ...    org_name=${org_name}
               ...    vnf_image_url=${vnf_image_url}
               ...    image_md5=${image_md5}
               ...    vnf_iso_url=http://${util1_fqdn}/${branch2_vnf1_name}.iso
               ...    vnf_name=${branch2_vnf1_name}
               ...    vnf_mem_size=${vnf_mem_size}
               ...    nsg_name=${branch2_nsg1_name}
               ...    segmentation_id=2

    Set Suite Variable    ${branch2_vnf_state}

Creating VNF for Branch3
    ${status}  ${branch3_vnf_state} =  Run Keyword And Ignore Error
                                       ...    NuageVNF.Get VNF
                                              ...    name=${branch3_vnf1_name}
                                              ...    cats_org_name=${org_name}

    # if vnf is created and its status is not RUNNING -> go thru the configuration steps
    ${branch3_vnf_state} =  Run Keyword If  $status == 'FAIL' or ($branch3_vnf_state.status != 'RUNNING')
        # user-defined kw, chech the keywords section in the end of this file
        ...    Create VNF And Attach Mgmt Interface
               ...    org_name=${org_name}
               ...    vnf_image_url=${vnf_image_url}
               ...    image_md5=${image_md5}
               ...    vnf_iso_url=http://${util1_fqdn}/${branch3_vnf1_name}.iso
               ...    vnf_name=${branch3_vnf1_name}
               ...    vnf_mem_size=${vnf_mem_size}
               ...    nsg_name=${branch3_nsg1_name}
               ...    segmentation_id=3

    Set Suite Variable    ${branch3_vnf_state}

Creating VNF for HQ
    ${status}  ${hq_vnf_state} =  Run Keyword And Ignore Error
                                  ...    NuageVNF.Get VNF
                                         ...    name=${hq_vnf1_name}
                                         ...    cats_org_name=${org_name}

    # if vnf is created and its status is not RUNNING -> go thru the configuration steps
    ${hq_vnf_state} =  Run Keyword If  $status == 'FAIL' or ($hq_vnf_state.status != 'RUNNING')
        # user-defined kw, chech the keywords section in the end of this file
        ...    Create VNF And Attach Mgmt Interface
               ...    org_name=${org_name}
               ...    vnf_image_url=${vnf_image_url}
               ...    image_md5=${image_md5}
               ...    vnf_iso_url=http://${util1_fqdn}/${hq_vnf1_name}.iso
               ...    vnf_name=${hq_vnf1_name}
               ...    vnf_mem_size=${vnf_mem_size}
               ...    nsg_name=${hq_nsg1_name}
               ...    segmentation_id=99

    Set Suite Variable    ${hq_vnf_state}

Deploy VNF in Branch1
    Run Keyword If  $branch1_vnf_state.status != 'RUNNING'
    ...    Deploy And Start VNF
           ...    org_name=${org_name}
           ...    vnf_name=${branch1_vnf1_name}

Deploy VNF in Branch2
    Run Keyword If  $branch2_vnf_state.status != 'RUNNING'
    ...    Deploy And Start VNF
           ...    org_name=${org_name}
           ...    vnf_name=${branch2_vnf1_name}

Deploy VNF in Branch3
    Run Keyword If  $branch3_vnf_state.status != 'RUNNING'
    ...    Deploy And Start VNF
           ...    org_name=${org_name}
           ...    vnf_name=${branch3_vnf1_name}

Deploy VNF in HQ
    Run Keyword If  $hq_vnf_state.status != 'RUNNING'
    ...    Deploy And Start VNF
           ...    org_name=${org_name}
           ...    vnf_name=${hq_vnf1_name}












*** Keywords ***
Create VNF And Attach Mgmt Interface
    [Arguments]
    ...    ${org_name}=${None}
    ...    ${vnf_image_url}=${None}
    ...    ${image_md5}=${None}
    ...    ${vnf_iso_url}=${None}
    ...    ${vnf_name}=${None}
    ...    ${vnf_mem_size}=2048
    ...    ${nsg_name}=${None}
    ...    ${segmentation_id}=${None}

    #### Generating VNF Metadata XML without boot iso md5 info
    ${vnf_xml} =  Load VNF Blob
                  ...    blob_template_name=${CURDIR}/data_files/vipe_metadata.xml
                  ...    image_url=${vnf_image_url}
                  ...    image_md5=${image_md5}
                  ...    iso_url=${vnf_iso_url}
                  ...    iso_md5=TBD

    Create File    ${CURDIR}/_CATS/${vnf_name}.xml    ${vnf_xml}
    ####

    #### Creating temporary VNF Metadata
    ${vnf_blob} =  OperatingSystem.Get File
                   ...    path=${CURDIR}/_CATS/${vnf_name}.xml

    Create VNF Metadata
    ...    name=${vnf_name}
    ...    blob=${vnf_blob}
    ####

    #### Creating VNF Descriptors
    Create VNF Descriptor
    ...    name=${vnf_name}_DESCRIPTOR
    ...    type=WAN_OPT
    ...    memoryMB=${vnf_mem_size}
    ...    storageGB=1
    ...    CPUCount=1
    ...    cats_vnf_metadata_name=${vnf_name}
    ####


    #### Creating VNF Interface Descriptors
    Create VNF Interface Descriptor
    ...    name=MANAGEMENT
    ...    type=MANAGEMENT
    ...    cats_vnf_descriptor_name=${vnf_name}_DESCRIPTOR

    Create VNF Interface Descriptor
    ...    name=LAN
    ...    type=LAN
    ...    cats_vnf_descriptor_name=${vnf_name}_DESCRIPTOR

    Create VNF Interface Descriptor
    ...    name=WAN
    ...    type=WAN
    ...    cats_vnf_descriptor_name=${vnf_name}_DESCRIPTOR
    ####

    #### Creating VNFs
    ${vnf_obj} =  Create VNF
                  ...    name=${vnf_name}
                  ...    cats_org_name=${org_name}
                  ...    cats_nsg_name=${nsg_name}
                  ...    cats_vnf_descriptor_name=${vnf_name}_DESCRIPTOR
    ####

    #### Assigning VNF managements interfaces to management subnets
    Edit VNF Interface
    ...    name=MANAGEMENT
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${vnf_mgmt_domain_name}
    ...    cats_subnet_name=${vnf_name}
    ...    cats_vnf_name=${vnf_name}
    ####

    #### Creating VNF Domain Mapping
    Create VNF Domain Mapping
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_nsg_name=${nsg_name}
    ...    segmentationID=${segmentation_id}

    #### Getting information to generate final boot ISOs
    # we need to get management subnets names to query for their gateway IP
    ${vnf_wan_if} =  Get VNF Interface
                     ...    name=WAN
                     ...    cats_org_name=${org_name}
                     ...    cats_vnf_name=${vnf_name}

    # create operation will set the network description
    # to the meaningful value and return the network object
    ${vnf_mgmt_sub} =  Network.Update Subnet
                       ...    name=${vnf_wan_if.network_name}
                       ...    description=${nsg_name}
                       ...    cats_org_name=${org_name}
                       ...    cats_domain_name=VNF Infrastructure domain

    # get Virtual IPs for WAN interfaces of VNFs
    ${vnf_wan_vip} =  Get Virtual IP List in vPort
                      ...    cats_org_name=${org_name}
                      ...    cats_domain_name=VNF Infrastructure domain
                      ...    cats_vport_name=${vnf_name}-WAN
    ####

    #### Templating Boot.iso.json files for VIPEs
    ${iso} =  CATSUtils.Render J2 Template
              ...    source=${CURDIR}/data_files/vipe.iso.json
              ...    inband_ip=${vnf_wan_vip[0].virtual_ip}
              ...    inband_netmask=255.255.255.240
              ...    inband_gw_ip=${vnf_mgmt_sub.gateway}
              ...    vipe_hostname=${vnf_name}
              ...    salsa_url=${salsa_url}
              ...    salsa_domain=${salsa_domain}

    Create File    ${CURDIR}/_CATS/${vnf_name}.iso.json    ${iso}
    ####

    #### Creating boot.iso files
    SSHLibrary.Execute Command
    ...    mkdir -p /tmp/configdrive/openstack/latest

    # transferring boot.iso.json file
    SSHLibrary.Put File
    ...    source=${CURDIR}/_CATS/${vnf_name}.iso.json
    ...    destination=/tmp/configdrive/openstack/latest/user_data

    SSHLibrary.Execute Command
    ...    mkisofs -R -V config-2 -o /var/www/html/${vnf_name}.iso /tmp/configdrive

    #### Generating final VNF Metadata XML with boot iso md5 info
    ${vnf_boot_iso_md5} =  SSHLibrary.Execute Command
                            ...    cd /var/www/html && md5sum ${vnf_name}.iso | awk '{print $1}'

    ${vnf_xml} =  Load VNF Blob
                  ...    blob_template_name=${CURDIR}/data_files/vipe_metadata.xml
                  ...    image_url=${vnf_image_url}
                  ...    image_md5=${image_md5}
                  ...    iso_url=${vnf_iso_url}
                  ...    iso_md5=${vnf_boot_iso_md5}

    Create File    ${CURDIR}/_CATS/${vnf_name}.xml    ${vnf_xml}
    ####

    #### Creating final VNF Metadata
    Create VNF Metadata
    ...    name=${vnf_name}
    ...    blob=${vnf_xml}
    ####

    [Return]  ${vnf_obj}


Deploy And Start VNF
    [Arguments]
    ...    ${org_name}=${None}
    ...    ${vnf_name}=${None}

    ${vnf} =  NuageVNF.Get VNF
              ...    name=${vnf_name}
              ...    cats_org_name=${org_name}
    
    Run Keyword If  $vnf.status == "INIT"
    ...    Deploy VNF And Then Start
           ...    org_name=${org_name}
           ...    vnf_name=${vnf_name}
    ...    ELSE IF  $vnf.status == "SHUTOFF"
           ...    Start VNF
                  ...    org_name=${org_name}
                  ...    vnf_name=${vnf_name}

Deploy VNF And Then Start
    [Arguments]
    ...    ${org_name}=${None}
    ...    ${vnf_name}=${None}

    NuageVNF.Deploy VNF
    ...    cats_org_name=${org_name}
    ...    cats_vnf_name=${vnf_name}

    NuageVNF.Wait For VNF Status
    ...    cats_org_name=${org_name}
    ...    cats_vnf_name=${vnf_name}
    ...    status=SHUTOFF

    NuageVNF.Start VNF
    ...    cats_org_name=${org_name}
    ...    cats_vnf_name=${vnf_name}

    NuageVNF.Wait For VNF Status
    ...    cats_org_name=${org_name}
    ...    cats_vnf_name=${vnf_name}
    ...    status=RUNNING

Start VNF
    [Arguments]
    ...    ${org_name}=${None}
    ...    ${vnf_name}=${None}

    NuageVNF.Start VNF
    ...    cats_org_name=${org_name}
    ...    cats_vnf_name=${vnf_name}

    NuageVNF.Wait For VNF Status
    ...    cats_org_name=${org_name}
    ...    cats_vnf_name=${vnf_name}
    ...    status=RUNNING
