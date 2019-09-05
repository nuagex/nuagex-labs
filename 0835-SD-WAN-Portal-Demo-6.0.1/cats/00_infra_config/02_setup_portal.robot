*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Connect to portal host
    ${conn} =  Linux.Connect To Server With Keys
               ...    server_address=${portal_mgmt_ip}
               ...    username=root
               ...    priv_key=${ssh_key_path}

Generate SSH keys
    SSHLibrary.Execute Command
    ...  mkdir -p /opt/vnsportal

    SSHLibrary.Execute Command
    ...  ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""

    SSHLibrary.Execute Command
    ...  cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

    SSHLibrary.Execute Command
    ...  cp /root/.ssh/id_rsa* /opt/vnsportal/
    ...  shell=True
    ...  sudo=True

Template portal configuration file
    Process.Run Process
    ...  curl -s ifconfig.io
    ...  shell=True
    ...  alias=lab_ip

    ${lab_ip} =  Process.Get Process Result
                 ...  lab_ip
                 ...  stdout=True

    ${data} =  CATSUtils.Render J2 Template
               ...  source=${CURDIR}/data/config.j2
               ...  portal_fqdn=${lab_ip}:443
               ...  local_ip=${portal_mgmt_ip}
               ...  vsd_fqdn=vsd.${domain}:8443
               ...  vsd_auth_username=proxy
               ...  vsd_auth_password=proxy
               ...  vstats_ip=${es_mgmt_ip}
               ...  servlet_session_secure=false

    SSHLibrary.Execute Command    cat > /opt/vnsportal/config.yml <<EOF${\n}${data}${\n}EOF

Run portal bootstrap scripts
    ${tag}=  SSHLibrary.Execute Command
    ...   docker images | grep installer | awk '{print $2}'

    SSHLibrary.Execute Command
    ...   docker run -ti --rm -v /var/run/docker.sock:/docker.sock -v /opt/vnsportal:/mnt:z nuage/vnsportal-installer:${tag} --skip
    ...   shell=True
    ...   sudo=True

Copy portal license file
    SSHLibrary.Execute Command
        ...  cp /home/centos/vns-portal.license /opt/vnsportal/tomcat-instance1/
        ...  shell=True
        ...  sudo=True

Start portal
    SSHLibrary.Execute Command
        ...  /opt/vnsportal/start.sh
        ...  shell=True
        ...  sudo=True
