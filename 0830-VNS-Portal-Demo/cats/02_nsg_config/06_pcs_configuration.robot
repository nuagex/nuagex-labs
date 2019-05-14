*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Update DHCP address for HQ PC1
    SSHLibrary.Switch Connection    ${hqpc1_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

Install HTTP Server and Required Packages for SIP on SF HQ PC
    SSHLibrary.Execute Command    yum install -y httpd ncurses-devel openssl-devel lksctp-tools-devel libpcap libpcap-devel

Copy Maillog File in SF HQ PC
    SSHLibrary.Put File
    ...  source=${CURDIR}/files/maillog
    ...  destination=/var/www/html
    
Connect to SF HQ PC and Add SSH Script Crontab 
    ${crontab_file} =  CATSUtils.Render J2 Template
                     ...    source=${CURDIR}/data/hq_crontab.j2
                     ...    mv_pc_address=${mv_pc1_data_addr}
                     ...    ny_pc_address=${ny_pc1_data_addr}
                     ...    hq_pc_address=${hq_pc1_data_addr}

    SSHLibrary.Execute Command    cat > /etc/crontab <<EOF${\n}${crontab_file}${\n}EOF

Copy mp4 file on HQ PC
    SSHLibrary.Execute Command    curl -L -O http://files.nuagedemos.net/livesp.mp4 

Copy SIPP library on HQ PC
    SSHLibrary.Execute Command    curl -L -O http://files.nuagedemos.net/software/sipp/sipp && chmod +x sipp 

Allow VLC to run as root User on HQ PC 
    SSHLibrary.Execute Command    sudo sed -i 's/geteuid/getppid/' /usr/bin/vlc

Update DHCP address for MV PC1
    SSHLibrary.Switch Connection    ${mvpc1_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

Install Required Packages for SIP on MV PC
    SSHLibrary.Execute Command    yum install -y ncurses-devel openssl-devel lksctp-tools-devel libpcap libpcap-devel

Connect to MV PC and Add SSH Script Crontab 
    ${crontab_file} =  CATSUtils.Render J2 Template
                     ...    source=${CURDIR}/data/mv_crontab.j2
                     ...    mv_pc_address=${mv_pc1_data_addr}
                     ...    ny_pc_address=${ny_pc1_data_addr}
                     ...    hq_pc_address=${hq_pc1_data_addr}

    SSHLibrary.Execute Command    cat > /etc/crontab <<EOF${\n}${crontab_file}${\n}EOF

Copy mp4 file on MV PC
    SSHLibrary.Execute Command    curl -L -O http://files.nuagedemos.net/livesp.mp4 

Copy SIPP library on MV PC
    SSHLibrary.Execute Command    curl -L -O http://files.nuagedemos.net/software/sipp/sipp && chmod +x sipp 

Allow VLC to run as root User on MV PC 
    SSHLibrary.Execute Command    sudo sed -i 's/geteuid/getppid/' /usr/bin/vlc

Update DHCP address for NY PC1
    SSHLibrary.Switch Connection    ${nypc1_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

Install Required Packages for SIP on NY PC
    SSHLibrary.Execute Command    yum install -y ncurses-devel openssl-devel lksctp-tools-devel libpcap libpcap-devel

Connect to NY PC and Add SSH Script Crontab 
    ${crontab_file} =  CATSUtils.Render J2 Template
                     ...    source=${CURDIR}/data/ny_crontab.j2
                     ...    mv_pc_address=${mv_pc1_data_addr}
                     ...    ny_pc_address=${ny_pc1_data_addr}
                     ...    hq_pc_address=${hq_pc1_data_addr}

    SSHLibrary.Execute Command    cat > /etc/crontab <<EOF${\n}${crontab_file}${\n}EOF

Copy mp4 file on NY PC
    SSHLibrary.Execute Command    curl -L -O http://files.nuagedemos.net/livesp.mp4 

Copy SIPP library on NY PC
    SSHLibrary.Execute Command    curl -L -O http://files.nuagedemos.net/software/sipp/sipp && chmod +x sipp 

Allow VLC to run as root User on NY PC 
    SSHLibrary.Execute Command    sudo sed -i 's/geteuid/getppid/' /usr/bin/vlc

Sleep 60 sec before verifying datapath
    # its been seen that immediate traffic emission could fail
    Sleep    60