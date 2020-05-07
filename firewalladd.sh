#!/bin/bash
expr $1 + 1 >/dev/null 2>&1
if [ $? -ne 0  ];then
    echo '输入的是不正确的端口号！！！'
else
    firewall-cmd --permanent --zone=public --add-port=$1/tcp
    firewall-cmd --reload
fi
