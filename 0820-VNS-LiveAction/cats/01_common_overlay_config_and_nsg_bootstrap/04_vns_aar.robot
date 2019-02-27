*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***

Create Custom Probe
    Create Performance Monitor in Organization
    ...    cats_org_name=${org_name} 
    ...    name=${perf_monit_name}
    ...    interval=30
    ...    numberOfPackets=1
    ...    payloadSize=137
    ...    serviceClass=H
    
Create Audio Stream application
    Create Application
    ...    cats_org_name=${org_name} 
    ...    name=Audio Stream
    ...    preClassificationPath=DEFAULT
    ...    protocol=TCP
    ...    destinationPort=4321
    ...    etherType=0x0800
    ...    enablePPS=False
    ...    DSCP=*

    Enable Application Performance Management
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=Audio Stream
    ...    oneWayLoss=20
    ...    oneWayDelay=250
    ...    oneWayJitter=100
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=Audio Stream
    ...    name=Allow All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

Create HTTP application
    Create Application
    ...    cats_org_name=${org_name} 
    ...    name=HTTP
    ...    preClassificationPath=DEFAULT
    ...    etherType=0x0800
    ...    enablePPS=False
    ...    DSCP=*

    Enable Application Performance Management
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=HTTP
    ...    oneWayLoss=30
    ...    oneWayDelay=200
    ...    oneWayJitter=200
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY

    Associate Application Signature to Application
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=HTTP
    ...    cats_application_signature_name=HTTP

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=HTTP
    ...    name=Allow All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

Create ICMP application
    Create Application
    ...    cats_org_name=${org_name} 
    ...    name=ICMP
    ...    preClassificationPath=DEFAULT
    ...    etherType=0x0800
    ...    enablePPS=False
    ...    DSCP=*

    Enable Application Performance Management
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=ICMP
    ...    oneWayLoss=2
    ...    oneWayDelay=20
    ...    oneWayJitter=20
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY

    Associate Application Signature to Application
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=ICMP
    ...    cats_application_signature_name=ICMP

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=ICMP
    ...    name=Allow All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

Create infoseek application
    Create Application
    ...    cats_org_name=${org_name} 
    ...    name=infoseek
    ...    preClassificationPath=DEFAULT
    ...    etherType=0x0800
    ...    enablePPS=False
    ...    DSCP=*

    Enable Application Performance Management
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=infoseek
    ...    oneWayLoss=20
    ...    oneWayDelay=200
    ...    oneWayJitter=100
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY

    Associate Application Signature to Application
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=infoseek
    ...    cats_application_signature_name=infoseek

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=infoseek
    ...    name=Allow All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

Create SSH application
    Create Application
    ...    cats_org_name=${org_name} 
    ...    name=ssh
    ...    preClassificationPath=DEFAULT
    ...    etherType=0x0800
    ...    enablePPS=False
    ...    DSCP=*

    Enable Application Performance Management
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=ssh
    ...    oneWayLoss=10
    ...    oneWayDelay=200
    ...    oneWayJitter=250
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY

    Associate Application Signature to Application
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=ssh
    ...    cats_application_signature_name=ssh

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=ssh
    ...    name=Allow All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

Create Video Stream RTP application
    Create Application
    ...    cats_org_name=${org_name} 
    ...    name=Video Stream RTP
    ...    protocol=UDP
    ...    preClassificationPath=DEFAULT
    ...    etherType=0x0800
    ...    enablePPS=False
    ...    DSCP=*

    Enable Application Performance Management
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=Video Stream RTP
    ...    oneWayLoss=10
    ...    oneWayDelay=250
    ...    oneWayJitter=100
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY

    Associate Application Signature to Application
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=Video Stream RTP
    ...    cats_application_signature_name=RTP

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=Video Stream RTP
    ...    name=Allow All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

Create Video Stream RSTP application
    Create Application
    ...    cats_org_name=${org_name} 
    ...    name=Video Stream RSTP
    ...    protocol=TCP
    ...    destinationPort=4321
    ...    preClassificationPath=DEFAULT
    ...    etherType=0x0800
    ...    enablePPS=False
    ...    DSCP=*

    Enable Application Performance Management
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=Video Stream RSTP
    ...    oneWayLoss=20
    ...    oneWayDelay=250
    ...    oneWayJitter=20
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY

    Associate Application Signature to Application
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=Video Stream RSTP
    ...    cats_application_signature_name=RTSP

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=Video Stream RSTP
    ...    name=Allow All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

Create Bronze APM Group
    Create APM Group
    ...    cats_org_name=${org_name} 
    ...    name=Bronze

    Associate Performance Monitor to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_performance_monitor_name=${perf_monit_name}
    ...    cats_apm_group_name=Bronze

Create Gold APM Group
    Create APM Group
    ...    cats_org_name=${org_name} 
    ...    name=Gold

    Associate Performance Monitor to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_performance_monitor_name=${perf_monit_name}
    ...    cats_apm_group_name=Gold

Create Silver APM Group
    Create APM Group
    ...    cats_org_name=${org_name} 
    ...    name=Silver

    Associate Performance Monitor to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_performance_monitor_name=${perf_monit_name}
    ...    cats_apm_group_name=Silver

Create ICMP APM Group
    Create APM Group
    ...    cats_org_name=${org_name} 
    ...    name=ICMP

    Associate Performance Monitor to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_performance_monitor_name=${perf_monit_name}
    ...    cats_apm_group_name=ICMP

Associate ICMP Application to ICMP APM Group
    Associate Application to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=ICMP
    ...    cats_apm_group_name=ICMP
    ...    priority=1

Associate SSH Application to Silver APM Group
    Associate Application to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=SSH
    ...    cats_apm_group_name=Silver
    ...    priority=0

Associate Audio Stream Application to Silver APM Group
    Associate Application to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=Audio Stream
    ...    cats_apm_group_name=Silver
    ...    priority=2

Associate HTTP Application to Bronze APM Group
    Associate Application to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=HTTP
    ...    cats_apm_group_name=Bronze
    ...    priority=1

Associate Video Stream RTP Application to Gold APM Group
    Associate Application to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=Video Stream RTP
    ...    cats_apm_group_name=Gold
    ...    priority=0

Associate Video Stream RSTP Application to Gold APM Group
    Associate Application to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=Video Stream RSTP
    ...    cats_apm_group_name=Gold
    ...    priority=2

Associate infoseek Application to Gold APM Group
    Associate Application to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=infoseek
    ...    cats_apm_group_name=Gold
    ...    priority=12

Assign NPM Groups to L3 Domain
    Associate APM Group to L3 Domain
    ...    cats_org_name=${org_name} 
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_apm_group_name=Gold
    ...    priority=10

    Associate APM Group to L3 Domain
    ...    cats_org_name=${org_name} 
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_apm_group_name=Silver
    ...    priority=20

    Associate APM Group to L3 Domain
    ...    cats_org_name=${org_name} 
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_apm_group_name=Bronze
    ...    priority=30

    Associate APM Group to L3 Domain
    ...    cats_org_name=${org_name} 
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_apm_group_name=ICMP
    ...    priority=40

    Associate NPM to L3 Domain
    ...    cats_org_name=${org_name} 
    ...    cats_domain_name=${customer_domain_name}
    ...    cats_npm_name=Default Network Performance Measurement
    ...    priority=5