*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          ../vars.robot
Suite Setup       Login NuageX User

*** Test Cases ***
Connect to ES VM
    ${conn} =  Linux.Connect To Server With Keys
               ...    server_address=${es_mgmt_ip}
               ...    username=root
               ...    priv_key=${ssh_key_path}

Copy Snapshot file
    SSHLibrary.Execute Command
    ...  cd /root && curl -L -O http://files.nuagedemos.net/elastic_portal_5.4.1.tar.gz
    ...  shell=True
    ...  sudo=True

Untar Snapshot file 
    SSHLibrary.Execute Command
    ...  cd /root && tar -zxvf elastic_portal_5.4.1.tar.gz
    ...  shell=True
    ...  sudo=True

Move directory 
    SSHLibrary.Execute Command
    ...  cd /root && mv nuage_elastic_backup/ /usr/local/bin/
    ...  shell=True
    ...  sudo=True

    SSHLibrary.Execute Command
    ...  echo "path.repo: ['/usr/local/bin/nuage_elastic_backup']" >> /etc/elasticsearch/elasticsearch.yml
    ...  shell=True
    ...  sudo=True

    SSHLibrary.Execute Command
    ...  systemctl status elasticsearch
    ...  shell=True
    ...  sudo=True

    SSHLibrary.Execute Command
    ...  curl -X PUT "localhost:9200/_snapshot/my_nuage_backup" -H 'Content-Type: application/json' -d' { "type": "fs", "settings": { "location": "/usr/local/bin/nuage_elastic_backup/", "compress": true } }'
    ...  shell=True
    ...  sudo=True