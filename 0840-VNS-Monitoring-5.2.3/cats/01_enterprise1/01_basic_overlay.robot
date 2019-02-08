*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Creating Organization Profile
    Create Organization Profile
    ...    name=${org_profile_name}
    ...    allowedForwardingClasses=@[A, B, C, D, E, F, G, H]
    ...    allowGatewayManagement=True
    ...    allowTrustedForwardingClass=True
    ...    BGPEnabled=True
    ...    DHCPLeaseInterval=24
    ...    enableApplicationPerformanceManagement=True
    ...    allowAdvancedQOSConfiguration=True
    ...    VNFManagementEnabled=True

Creating Organization
    Create Organization
    ...    name=${org_name}
    ...    localAS=65000
    ...    cats_org_profile_name=${org_profile_name}

Creating L3 domain template
    Create L3 Domain Template
    ...    name=${l3domain_template1_name}
    ...    cats_org_name=${org_name}

Enabling DPI on L3 domain template
    Enable DPI at L3 Domain Template
    ...    cats_org_name=${org_name}
    ...    cats_domain_template_name=${l3domain_template1_name}

Creating L3 domain
    Create L3 Domain
    ...    name=${l3domain_name}
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_template_name=${l3domain_template1_name}
    ...    underlayEnabled=ENABLED
    ...    PATEnabled=ENABLED

    Create DHCP Option in L3 Domain
        ...    cats_org_name=${org_name}
        ...    cats_domain_name=${l3domain_name}
        ...    actualType=6
        ...    actualValues=@[8.8.8.8]

Creating a Zone
    Create Zone
    ...    name=${zone_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}

Creating Subnets
    Create Subnet
    ...    name=${subnet1_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${zone_name}
    ...    cats_address=${subnet1_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${subnet1_name}
    ...    minAddress=${branch_pc1_data_addr}
    ...    maxAddress=${branch_pc1_data_addr}

    Create Subnet
    ...    name=${subnet2_name}
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_zone_name=${zone_name}
    ...    cats_address=${subnet2_network_addr}

    Create Address Range in Subnet
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_subnet_name=${subnet2_name}
    ...    minAddress=${branch_pc2_data_addr}
    ...    maxAddress=${branch_pc2_data_addr}

Create default security policy
    Begin Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${l3domain_name}

    Create Ingress Security Policy in L3 Domain
    ...    name=${sec_policy1_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    allowAddressSpoof=True
    ...    defaultAllowIP=True
    ...    defaultAllowNonIP=True

    Create Egress Security Policy in L3 Domain
    ...    name=${sec_policy1_name}
    ...    active=True
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    defaultAllowIP=True
    ...    defaultAllowNonIP=True

    Apply Policy Changes
    ...    cats_org_name=${org_name}
    ...    cats_L3_domain_name=${l3domain_name}

Creating Underlays
    Create Underlay in Platform Configuration
    ...    name=MPLS

    Create Underlay in Platform Configuration
    ...    name=Internet

Creating Applications
    Create Application
    ...    cats_org_name=${org_name}
    ...    name=Audio Stream
    ...    preClassificationPath=DEFAULT
    ...    protocol=TCP
    ...    destinationPort=4321
    ...    etherType=0x0800
    ...    enablePPS=True
    ...    oneWayDelay=250
    ...    oneWayJitter=100
    ...    oneWayLoss=20
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY
    ...    DSCP=*

    Create Application
    ...    cats_org_name=${org_name}
    ...    cats_application_signature_name=RTP
    ...    name=Video Stream RTP
    ...    preClassificationPath=DEFAULT
    ...    protocol=UDP
    ...    etherType=0x0800
    ...    enablePPS=True
    ...    oneWayDelay=250
    ...    oneWayJitter=100
    ...    oneWayLoss=10
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY
    ...    DSCP=*

    Create Application
    ...    cats_org_name=${org_name}
    ...    cats_application_signature_name=RTSP
    ...    name=Video Stream RTSP
    ...    preClassificationPath=DEFAULT
    ...    protocol=TCP
    ...    destinationPort=4321
    ...    etherType=0x0800
    ...    enablePPS=True
    ...    oneWayDelay=250
    ...    oneWayJitter=20
    ...    oneWayLoss=20
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY
    ...    DSCP=*

    Create Application
    ...    cats_org_name=${org_name}
    ...    name=SSH
    ...    cats_application_signature_name=SSH
    ...    preClassificationPath=DEFAULT
    ...    etherType=0x0800
    ...    enablePPS=True
    ...    oneWayDelay=200
    ...    oneWayJitter=250
    ...    oneWayLoss=10
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY
    ...    DSCP=*

    Create Application
    ...    cats_org_name=${org_name}
    ...    cats_application_signature_name=HTTP
    ...    name=HTTP
    ...    preClassificationPath=DEFAULT
    ...    etherType=0x0800
    ...    enablePPS=True
    ...    oneWayDelay=200
    ...    oneWayJitter=200
    ...    oneWayLoss=30
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY
    ...    DSCP=*

Creating Performance Monitor
    Create Performance Monitor in Organization
        ...    cats_org_name=${org_name}
        ...    name=Custom Probe
        ...    interval=30
        ...    numberOfPackets=1
        ...    payloadSize=137
        ...    serviceClass=H

Associating Monitor Scopes
    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=Audio Stream
    ...    name=All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=Video Stream RTP
    ...    name=All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=Video Stream RTSP
    ...    name=All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=SSH
    ...    name=All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=HTTP
    ...    name=All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

Createing APM Groups
    Create APM Group
    ...    cats_org_name=${org_name}
    ...    name=Gold

    Associate Performance Monitor to APM Group
    ...    cats_org_name=${org_name}
    ...    cats_performance_monitor_name=Custom Probe
    ...    cats_apm_group_name=Gold

    Associate Application to APM Group
    ...    cats_org_name=${org_name}
    ...    cats_application_name=Video Stream RTP
    ...    cats_apm_group_name=Gold
    ...    priority=1

    Associate Application to APM Group
    ...    cats_org_name=${org_name}
    ...    cats_application_name=Video Stream RTSP
    ...    cats_apm_group_name=Gold
    ...    priority=2

    Create APM Group
    ...    cats_org_name=${org_name}
    ...    name=Silver

    Associate Performance Monitor to APM Group
    ...    cats_org_name=${org_name}
    ...    cats_performance_monitor_name=Custom Probe
    ...    cats_apm_group_name=Silver

    Associate Application to APM Group
    ...    cats_org_name=${org_name}
    ...    cats_application_name=SSH
    ...    cats_apm_group_name=Silver
    ...    priority=1

    Associate Application to APM Group
    ...    cats_org_name=${org_name}
    ...    cats_application_name=Audio Stream
    ...    cats_apm_group_name=Silver
    ...    priority=2
    
    Create APM Group
    ...    cats_org_name=${org_name}
    ...    name=Bronze

    Associate Performance Monitor to APM Group
    ...    cats_org_name=${org_name}
    ...    cats_performance_monitor_name=Custom Probe
    ...    cats_apm_group_name=Bronze

    Associate Application to APM Group
    ...    cats_org_name=${org_name}
    ...    cats_application_name=HTTP
    ...    cats_apm_group_name=Bronze
    ...    priority=1

Associating APM Groups to Domain
    Associate APM Group to L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_apm_group_name=Gold
    ...    priority=10

    Associate APM Group to L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_apm_group_name=Silver
    ...    priority=20

    Associate APM Group to L3 Domain
    ...    cats_org_name=${org_name}
    ...    cats_domain_name=${l3domain_name}
    ...    cats_apm_group_name=Bronze
    ...    priority=30