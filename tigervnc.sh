#!/bin/bash
# 本脚本用于安装tigervnc-server服务，默认使用的是root用户，
# 参考了[CentOS 7安装TigerVNC Server](https://blog.csdn.net/wamath/article/details/76003128)


yum install -y tigervnc-server
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service
sed -i 's/<USER>/root/' /etc/systemd/system/vncserver@:1.service

systemctl daemon-reload
systemctl enable vncserver@:1.service
firewall-cmd --state
if [ $? -ne 0 ]; then
    systemctl start firewalld
fi
firewall-cmd --permanent --zone=public --add-port=5901-5905/tcp
firewall-cmd --reload
# vncserver
systemctl daemon-reload
systemctl restart vncserver@:1.service

