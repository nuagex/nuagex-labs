*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Create VNF for LAN
    ${status}  ${fortinet_vnf_orig_state} =  Run Keyword And Ignore Error
                                            ...    NuageVNF.Get VNF
                                                   ...    name=${fortinet_vnf_name} 
                                                   ...    cats_org_name=${org_name}


    # if vnf is created and its status is not RUNNING -> go thru the configuration steps
    ${branch1_vnf_state} =  Run Keyword If  $status == 'FAIL' or ($fortinet_vnf_orig_state.status != 'RUNNING')
        # user-defined kw, chech the keywords section in the end of this file
        ...    Create VNF And Attach Mgmt Interface
               ...    org_name=${org_name}
               ...    vnf_name=${fortinet_vnf_name}
               ...    vnf_mem_size=${vnf_mem_size}
               ...    nsg_name=${hq_nsg1_name}
               ...    segmentation_id=1
        ...  ELSE
             ...    Get Variable Value    ${fortinet_vnf_orig_state}

    Set Suite Variable     ${branch1_vnf_state}


*** Keywords ***
Create VNF And Attach Mgmt Interface
    [Arguments]
    ...    ${org_name}=${None}
    ...    ${vnf_name}=${None}
    ...    ${vnf_mem_size}=6656
    ...    ${nsg_name}=${None}
    ...    ${segmentation_id}=${None}

    ##### Get md5sum of boot ISO
    #####

    #### Generating VNF Metadata XML
    ${vnf_xml} =  Load VNF Blob
                  ...    blob_template_name=${CURDIR}/data_files/vnf_metadata.xml
                  ...    image_url=http://util.lab.local/fortios.qcow2
                  ...    image_md5=588df9ba0db485976f6681810001ae73
                  ...    iso_url=http://util.lab.local/fortinet.iso
                  ...    iso_md5=4190fe57ae3526349dd4a18895b291a3

    Create File    ${CURDIR}/_CATS/${vnf_name}.xml    ${vnf_xml}
    ####

    #### Creating VNF Metadata
    ${vnf_blob} =  OperatingSystem.Get File
                   ...    path=${CURDIR}/_CATS/${vnf_name}.xml

    Create VNF Metadata
    ...    name=${vnf_name}
    ...    blob=${vnf_blob}
    ####

    #### Creating VNF Descriptors
    Create VNF Descriptor
    ...    name=${vnf_name}_DESCRIPTOR
    ...    type=FIREWALL
    ...    memoryMB=${vnf_mem_size}
    ...    storageGB=60
    ...    CPUCount=2
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
    ...    cats_domain_name=${managment_domain_name}
    ...    cats_subnet_name=${vnf_mgmt_subnet_name} 
    ...    cats_vnf_name=${vnf_name}
    ####

    #### Creating VNF Domain Mapping
    Create VNF Domain Mapping
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${customer_domain_name}
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

    [Return]  ${vnf_obj}


