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

Install HTTP Server and Required Packages on SF HQ PC
    SSHLibrary.Execute Command    yum install -y httpd hping3

Copy files to SF HQ PC
    SSHLibrary.Put File
    ...  source=${CURDIR}/files/maillog
    ...  destination=/var/www/html

    SSHLibrary.Put File
    ...  source=${CURDIR}/files/browse.sh
    ...  destination=/root
    ...  mode=0755

    SSHLibrary.Put File
    ...  source=${CURDIR}/files/lnkdn.sh
    ...  destination=/root
    ...  mode=0755
    
Connect to SF HQ PC and Add SSH Script Crontab 
    ${crontab_file} =  CATSUtils.Render J2 Template
                     ...    source=${CURDIR}/data/hq_sf_crontab.j2
                     ...    pa_pc_address=${pa_pc1_data_addr}
                     ...    sj_pc_address=${sj_pc1_data_addr}
                     ...    hq_pc_address=${hq_sf_pc1_data_addr}

    SSHLibrary.Execute Command    cat > /etc/crontab <<EOF${\n}${crontab_file}${\n}EOF

############################################################################################################################################

Update DHCP address for PA PC1
    SSHLibrary.Switch Connection    ${papc1_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

Transfer scripts to PA PC1
    SSHLibrary.Put File
    ...  source=${CURDIR}/files/cnn.sh
    ...  destination=/root
    ...  mode=0755

    SSHLibrary.Put File
    ...  source=${CURDIR}/files/steam.sh
    ...  destination=/root
    ...  mode=0755

Install Required Packages on PA PC
    SSHLibrary.Execute Command    yum install -y hping3

Connect to PA PC and Add SSH Script Crontab 
    ${crontab_file} =  CATSUtils.Render J2 Template
                     ...    source=${CURDIR}/data/pa_crontab.j2
                     ...    pa_pc_address=${pa_pc1_data_addr}
                     ...    sj_pc_address=${sj_pc1_data_addr}
                     ...    hq_pc_address=${hq_sf_pc1_data_addr}

    SSHLibrary.Execute Command    cat > /etc/crontab <<EOF${\n}${crontab_file}${\n}EOF

Add Portal hostname
    SSHLibrary.Execute Command    echo '192.168.10.100 ion-motors.lab' >> /etc/hosts

################################################################################################################################
Update DHCP address for PA Tablet
    SSHLibrary.Switch Connection    ${patablet_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

Copy files to PA Tablet
    SSHLibrary.Put File
    ...  source=${CURDIR}/files/guest.sh
    ...  destination=/root
    ...  mode=0755

    SSHLibrary.Put File
    ...  source=${CURDIR}/files/syn_flag.sh
    ...  destination=/root
    ...  mode=0755

Install Required Packages for PA Tablet
    SSHLibrary.Execute Command    yum -y install hping3

Connect to PA Tablet and Add SSH Script Crontab 
    ${crontab_file} =  CATSUtils.Render J2 Template
                     ...    source=${CURDIR}/data/pa_tablet_crontab.j2
                     ...    pa_pc_address=${pa_pc1_data_addr}
                     ...    sj_pc_address=${sj_pc1_data_addr}
                     ...    hq_pc_address=${hq_sf_pc1_data_addr}
                     ...    pa_tablet_address=${pa_tablet_data_addr}

    SSHLibrary.Execute Command    cat > /etc/crontab <<EOF${\n}${crontab_file}${\n}EOF

Add Portal hostname
    SSHLibrary.Execute Command    echo '192.168.10.100 ion-motors.lab' >> /etc/hosts

#################################################################################################################################
Update DHCP address for SJ PC1
    SSHLibrary.Switch Connection    ${sjpc1_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

Install Required Packages on SJ PC
    SSHLibrary.Execute Command    yum install -y hping3

Connect to SJ PC and Add SSH Script Crontab 
    ${crontab_file} =  CATSUtils.Render J2 Template
                     ...    source=${CURDIR}/data/sj_crontab.j2
                     ...    pa_pc_address=${pa_pc1_data_addr}
                     ...    sj_pc_address=${sj_pc1_data_addr}
                     ...    hq_pc_address=${hq_sf_pc1_data_addr}

    SSHLibrary.Execute Command    cat > /etc/crontab <<EOF${\n}${crontab_file}${\n}EOF

#################################################################################################################################
Update DHCP address for SJ Mobile
    SSHLibrary.Switch Connection    ${sjmobile_conn}

    SSHLibrary.Execute Command
    ...    ip netns exec ns-data dhclient --no-pid eth1
    ...    sudo=True

Install Required Packages for SJ Mobile
    SSHLibrary.Execute Command    yum -y install hping3

Copy files to SJ Mobile
    SSHLibrary.Put File
    ...  source=${CURDIR}/files/guest.sh
    ...  destination=/root

Connect to SJ Mobile and Add SSH Script Crontab 
    ${crontab_file} =  CATSUtils.Render J2 Template
                     ...    source=${CURDIR}/data/sj_mobile_crontab.j2
                     ...    pa_pc_address=${pa_pc1_data_addr}
                     ...    sj_pc_address=${sj_pc1_data_addr}
                     ...    hq_pc_address=${hq_sf_pc1_data_addr}
                     ...    pa_tablet_address=${pa_tablet_data_addr}
                     ...    sj_mobile_address=${sj_mobile_data_addr}
Add Portal hostname
    SSHLibrary.Execute Command    echo '192.168.10.100 ion-motors.lab' >> /etc/hosts

Sleep 60 sec before verifying datapath
    # its been seen that immediate traffic emission could fail
    Sleep    60