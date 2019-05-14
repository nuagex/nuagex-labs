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

Create IPERF application
    Create Application
    ...    cats_org_name=${org_name} 
    ...    name=IPERF
    ...    preClassificationPath=DEFAULT
    ...    protocol=TCP
    ...    destinationPort=5201
    ...    etherType=0x0800
    ...    enablePPS=False
    ...    DSCP=*

    Enable Application Performance Management
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=IPERF
    ...    oneWayLoss=1
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=IPERF
    ...    name=Allow All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

Create IPERF RETURN application
    Create Application
    ...    cats_org_name=${org_name} 
    ...    name=IPERF RETURN
    ...    preClassificationPath=DEFAULT
    ...    protocol=TCP
    ...    etherType=0x0800
    ...    enablePPS=False
    ...    DSCP=*

    Enable Application Performance Management
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=IPERF RETURN
    ...    oneWayLoss=1
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=IPERF RETURN
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

Create VLC application
    Create Application
    ...    cats_org_name=${org_name} 
    ...    name=VLC
    ...    preClassificationPath=DEFAULT
    ...    protocol=TCP
    ...    destinationPort=1234
    ...    etherType=0x0800
    ...    enablePPS=False
    ...    DSCP=*

    Enable Application Performance Management
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=VLC
    ...    oneWayLoss=20
    ...    oneWayDelay=200
    ...    oneWayJitter=100
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY

    Associate Application Signature to Application
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=VLC
    ...    cats_application_signature_name=infoseek

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=VLC
    ...    name=Allow All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

Create SSH application
    Create Application
    ...    cats_org_name=${org_name} 
    ...    name=SSH
    ...    preClassificationPath=DEFAULT
    ...    etherType=0x0800
    ...    enablePPS=False
    ...    DSCP=*

    Enable Application Performance Management
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=SSH
    ...    oneWayLoss=10
    ...    oneWayDelay=200
    ...    oneWayJitter=250
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY

    Associate Application Signature to Application
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=SSH
    ...    cats_application_signature_name=ssh

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=SSH
    ...    name=Allow All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

Create VoIP application
    Create Application
    ...    cats_org_name=${org_name} 
    ...    name=VoIP
    ...    preClassificationPath=DEFAULT
    ...    etherType=0x0800
    ...    enablePPS=False
    ...    DSCP=*

    Enable Application Performance Management
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=VoIP
    ...    oneWayLoss=10
    ...    oneWayDelay=200
    ...    oneWayJitter=250
    ...    performanceMonitorType=FIRST_PACKET_AND_CONTINUOUS
    ...    optimizePathSelection=LATENCY

    Associate Application Signature to Application
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=VoIP
    ...    cats_application_signature_name=SIP

    Associate Monitor Scope to Application
    ...    cats_org_name=${org_name}
    ...    cats_application_name=VoIP
    ...    name=Allow All
    ...    allowAllSourceNSGs=True
    ...    allowAllDestinationNSGs=True

Create Diamond APM Group
    Create APM Group
    ...    cats_org_name=${org_name} 
    ...    name=Diamond

    Associate Performance Monitor to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_performance_monitor_name=${perf_monit_name}
    ...    cats_apm_group_name=Diamond


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

Create Bronze APM Group
    Create APM Group
    ...    cats_org_name=${org_name} 
    ...    name=Bronze

    Associate Performance Monitor to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_performance_monitor_name=${perf_monit_name}
    ...    cats_apm_group_name=Bronze

Associate VoIP Application to Gold APM Group
    Associate Application to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=VoIP
    ...    cats_apm_group_name=Diamond
    ...    priority=10

Associate VLC Application to Gold APM Group
    Associate Application to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=VLC
    ...    cats_apm_group_name=Gold
    ...    priority=10

Associate SSH Application to Silver APM Group
    Associate Application to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=SSH
    ...    cats_apm_group_name=Silver
    ...    priority=10

Associate HTTP RETURN Application to Bronze APM Group
    Associate Application to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=HTTP
    ...    cats_apm_group_name=Bronze
    ...    priority=10

Associate IPERF Application to Bronze APM Group
    Associate Application to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=IPERF
    ...    cats_apm_group_name=Bronze
    ...    priority=20

Associate IPERF RETURN Application to Bronze APM Group
    Associate Application to APM Group
    ...    cats_org_name=${org_name} 
    ...    cats_application_name=IPERF RETURN
    ...    cats_apm_group_name=Bronze
    ...    priority=30

Assign NPM Groups to L3 Domain
    Associate APM Group to L3 Domain
    ...    cats_org_name=${org_name} 
    ...    cats_domain_name=${l3domain_name}
    ...    cats_apm_group_name=Diamond
    ...    priority=10

    Associate APM Group to L3 Domain
    ...    cats_org_name=${org_name} 
    ...    cats_domain_name=${l3domain_name}
    ...    cats_apm_group_name=Gold
    ...    priority=20

    Associate APM Group to L3 Domain
    ...    cats_org_name=${org_name} 
    ...    cats_domain_name=${l3domain_name}
    ...    cats_apm_group_name=Silver
    ...    priority=30

    Associate APM Group to L3 Domain
    ...    cats_org_name=${org_name} 
    ...    cats_domain_name=${l3domain_name}
    ...    cats_apm_group_name=Bronze
    ...    priority=40

    Associate NPM to L3 Domain
    ...    cats_org_name=${org_name} 
    ...    cats_domain_name=${l3domain_name}
    ...    cats_npm_name=Default Network Performance Measurement
    ...    priority=50