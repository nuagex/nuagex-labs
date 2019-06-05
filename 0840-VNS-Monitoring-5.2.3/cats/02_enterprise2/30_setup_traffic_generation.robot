*** Settings ***
Resource          cats_lib/resources/cats_common.robot
Resource          vars.robot

*** Test Cases ***
Setup Traffic Generation PC3
    SSHLibrary.Switch Connection    ${brpc3_conn}

    SSHLibrary.Put File
    ...    source=${CURDIR}/data_files/crontab_pc3
    ...    destination=/etc/crontab

    SSHLibrary.Put File
    ...    source=${CURDIR}/data_files/generic_ssh_key
    ...    destination=/root/.ssh/id_rsa
    ...    mode=400

    SSHLibrary.Execute Command
    ...    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDj+D9HuIFGu/WbVOMs5J2mF9hfHTRgf1Ll6t8Lk7rdtoPrHrVEylQNT93AzNWNr6S9SQ34SEOqBqywWJye87e7Kp7hzX0VmPk16VQIU3B/QUoj9i9mnLA6j7qP9xsTAYioxqGu1T6Y/kQseAQ1+IjCWr6bEAIV9L7dDGbgWjumK+Js+uW/4Iea0WxRJBYShY/Kkbh+FAUFS9OvgmlrA8y70bFqfS/XNQnOCS4R1xAdAeRZEiB13ABxQpwKtq251jwxkZhMkxR2+OQMKDOotyfrWPMnH082MqL+2ZR8lqocyy3N4fBIXI2UOnER8b8z9ZMjhyFdetSCroHcNpe9Zm2B" >> /root/.ssh/authorized_keys

    SSHLibrary.Execute Command
    ...    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp1jOfykpTTiY6LLOyMyWbwGFtK0TWJsYW877FSMLnIxEeYvqz9MHu/fRFA2bQSzP6XC+cw4TWjA0awAC5UwWwqkzP/3jYcZhB4OnS/hrY6OoGM84h0XKP8teIyxHxHmk6XI8rNNrIyg5dyWm8hWsY0s9rVbF/aJEDhyemkSACTUu7MxY5ao1l3D0pOVecVmNQaH0LmG7XHtHiFKeFgjtZ3JtzTI3wcJFQCMM6k4hAHoAdCk/a+39rC+mHOqN9v/K3EY33YH7qWIamz7JApIlGN0EEjGeMCyoxVuBXMf/qdGCOpOdUXVp6wrdhrWN471TlInkc5dgGAIPArM21w7GD" >> /root/.ssh/authorized_keys


Setup Traffic Generation PC4
    SSHLibrary.Switch Connection    ${brpc4_conn}

    SSHLibrary.Put File
    ...    source=${CURDIR}/data_files/crontab_pc4
    ...    destination=/etc/crontab

    SSHLibrary.Put File
    ...    source=${CURDIR}/data_files/generic_ssh_key
    ...    destination=/root/.ssh/id_rsa
    ...    mode=400

    SSHLibrary.Execute Command
    ...    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDj+D9HuIFGu/WbVOMs5J2mF9hfHTRgf1Ll6t8Lk7rdtoPrHrVEylQNT93AzNWNr6S9SQ34SEOqBqywWJye87e7Kp7hzX0VmPk16VQIU3B/QUoj9i9mnLA6j7qP9xsTAYioxqGu1T6Y/kQseAQ1+IjCWr6bEAIV9L7dDGbgWjumK+Js+uW/4Iea0WxRJBYShY/Kkbh+FAUFS9OvgmlrA8y70bFqfS/XNQnOCS4R1xAdAeRZEiB13ABxQpwKtq251jwxkZhMkxR2+OQMKDOotyfrWPMnH082MqL+2ZR8lqocyy3N4fBIXI2UOnER8b8z9ZMjhyFdetSCroHcNpe9Zm2B" >> /root/.ssh/authorized_keys

    SSHLibrary.Execute Command
    ...    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp1jOfykpTTiY6LLOyMyWbwGFtK0TWJsYW877FSMLnIxEeYvqz9MHu/fRFA2bQSzP6XC+cw4TWjA0awAC5UwWwqkzP/3jYcZhB4OnS/hrY6OoGM84h0XKP8teIyxHxHmk6XI8rNNrIyg5dyWm8hWsY0s9rVbF/aJEDhyemkSACTUu7MxY5ao1l3D0pOVecVmNQaH0LmG7XHtHiFKeFgjtZ3JtzTI3wcJFQCMM6k4hAHoAdCk/a+39rC+mHOqN9v/K3EY33YH7qWIamz7JApIlGN0EEjGeMCyoxVuBXMf/qdGCOpOdUXVp6wrdhrWN471TlInkc5dgGAIPArM21w7GD" >> /root/.ssh/authorized_keys


Setup Traffic Generation PC5
    SSHLibrary.Switch Connection    ${brpc5_conn}

    SSHLibrary.Put File
    ...    source=${CURDIR}/data_files/crontab_pc5
    ...    destination=/etc/crontab

    SSHLibrary.Put File
    ...    source=${CURDIR}/data_files/generic_ssh_key
    ...    destination=/root/.ssh/id_rsa
    ...    mode=400

    SSHLibrary.Execute Command
    ...    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDj+D9HuIFGu/WbVOMs5J2mF9hfHTRgf1Ll6t8Lk7rdtoPrHrVEylQNT93AzNWNr6S9SQ34SEOqBqywWJye87e7Kp7hzX0VmPk16VQIU3B/QUoj9i9mnLA6j7qP9xsTAYioxqGu1T6Y/kQseAQ1+IjCWr6bEAIV9L7dDGbgWjumK+Js+uW/4Iea0WxRJBYShY/Kkbh+FAUFS9OvgmlrA8y70bFqfS/XNQnOCS4R1xAdAeRZEiB13ABxQpwKtq251jwxkZhMkxR2+OQMKDOotyfrWPMnH082MqL+2ZR8lqocyy3N4fBIXI2UOnER8b8z9ZMjhyFdetSCroHcNpe9Zm2B" >> /root/.ssh/authorized_keys

    SSHLibrary.Execute Command
    ...    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp1jOfykpTTiY6LLOyMyWbwGFtK0TWJsYW877FSMLnIxEeYvqz9MHu/fRFA2bQSzP6XC+cw4TWjA0awAC5UwWwqkzP/3jYcZhB4OnS/hrY6OoGM84h0XKP8teIyxHxHmk6XI8rNNrIyg5dyWm8hWsY0s9rVbF/aJEDhyemkSACTUu7MxY5ao1l3D0pOVecVmNQaH0LmG7XHtHiFKeFgjtZ3JtzTI3wcJFQCMM6k4hAHoAdCk/a+39rC+mHOqN9v/K3EY33YH7qWIamz7JApIlGN0EEjGeMCyoxVuBXMf/qdGCOpOdUXVp6wrdhrWN471TlInkc5dgGAIPArM21w7GD" >> /root/.ssh/authorized_keys

