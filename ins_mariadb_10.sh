#!/bin/bash
# 本脚本用于安装mariadb 10

# 添加mariadb10.2的国内yum源
echo '[mariadb]' > /etc/yum.repos.d/Mariadb.repo
echo 'name = MariaDB' >> /etc/yum.repos.d/Mariadb.repo
echo 'baseurl = https://mirrors.ustc.edu.cn/mariadb/yum/10.2/centos7-amd64' >> /etc/yum.repos.d/Mariadb.repo
echo 'gpgkey=https://mirrors.ustc.edu.cn/mariadb/yum/RPM-GPG-KEY-MariaDB' >> /etc/yum.repos.d/Mariadb.repo
echo 'gpgcheck=1' >> /etc/yum.repos.d/Mariadb.repo

# 清除yum源缓存数据 && 生成新的yum源数据缓存
yum clean all && yum makecache

# 安装
yum install MariaDB-server MariaDB-client -y

# 启动并添加开机自启
systemctl start mariadb.service
systemctl enable mariadb.service

# mariadb的初始化
# mysql_secure_installation