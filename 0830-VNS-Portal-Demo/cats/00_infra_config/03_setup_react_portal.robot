*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Connect to react portal host
    ${conn} =  Linux.Connect To Server With Keys
               ...    server_address=${portal_react_mgmt_ip}
               ...    username=root
               ...    priv_key=${ssh_key_path}

Install docker and docker compose on react Portal VM
    [Tags]  portal-docker-installation

    SSHLibrary.Execute Command
    ...  yum -y install epel-release https://centos7.iuscommunity.org/ius-release.rpm yum-utils
    ...  shell=True
    ...  sudo=True

    SSHLibrary.Execute Command
    ...  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    ...  shell=True
    ...  sudo=True

    SSHLibrary.Execute Command
    ...  yum -y install docker-ce && sudo systemctl enable docker && sudo systemctl start docker
    ...  shell=True
    ...  sudo=True

    SSHLibrary.Execute Command
    ...  curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose && ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    ...  shell=True
    ...  sudo=True

Template react portal configuration file
    Process.Run Process
    ...  curl -s ifconfig.io
    ...  shell=True
    ...  alias=lab_ip

    ${lab_ip} =  Process.Get Process Result
                 ...  lab_ip
                 ...  stdout=True

    ${data} =  CATSUtils.Render J2 Template
               ...  source=${CURDIR}/data/portal_vars.j2
               ...  portal_fqdn=${lab_ip}:2443
               ...  vsd_fqdn=vsd.${domain}:8443
               ...  vsd_auth_username=proxy
               ...  vsd_auth_password=proxy
               ...  vstats_ip=${es_mgmt_ip}
               ...  servlet_session_secure=false

    SSHLibrary.Execute Command    cat > /home/centos/portal.properties <<EOF${\n}${data}${\n}EOF

Download docker images tar file 
    SSHLibrary.Execute Command
        ...  cd /root && curl -L -O  ${react_file_url}
        ...  shell=True
        ...  sudo=True

Import images 
    SSHLibrary.Execute Command
        ...  gunzip -c /root/${react_tar_file_name} | docker load
        ...  shell=True
        ...  sudo=True

Run portal bootstrap scripts
    SSHLibrary.Execute Command
        ...  docker run --rm --env-file /home/centos/portal.properties -v /var/run/docker.sock:/docker.sock -v /opt:/mnt:z -v /etc:/hostetc:z nuage/vnsportal-bootstrap:5.3.0-5
        ...  shell=True
        ...  sudo=True

Copy portal license file
    SSHLibrary.Put File
    ...  source=${CURDIR}/data/react-portal.license
    ...  destination=/home/centos/vns-portal.license

    SSHLibrary.Execute Command
        ...  cp /home/centos/vns-portal.license /opt/vnsportal/tomcat-instance1/
        ...  shell=True
        ...  sudo=True

Start portal
    SSHLibrary.Execute Command
        ...  /opt/vnsportal/start.sh
        ...  shell=True
        ...  sudo=True