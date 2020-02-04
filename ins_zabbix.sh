#!/bin/bash

###########本脚本用于安装zabbix 4.0 ######
#
#
#
#
##########################################
# 设置要使用的全局变量
DBAdminUser=root
DBAdminPass=ykadmin123
ZabbixDBUser=zabbix
ZabbixDBPass=ykadmin123

yum -y update
# 关闭selinux，重启后才能生效
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# 关闭防火墙
systemctl stop firewalld
systemctl disable firewalld

# 搭建LAMP环境
yum install -y httpd mariadb-server mariadb php php-mysql php-gd libjpeg* php-ldap php-odbc php-pear php-xml php-xmlrpc php-mhash

# 安装完成后检查应用版本
rpm -qa httpd php mariadb

# 编辑httpd
sed -i "s/#ServerName www.example.com:80/ServerName zabbix.gyc.tl:80/g" /etc/httpd/conf/httpd.conf
sed -i "s/DirectoryIndex index.html/DirectoryIndex index.html index.php/g" /etc/httpd/conf/httpd.conf

# 编辑配置php，配置中国时区
sed -i "s/;date.timezone =/date.timezone = PRC/g" /etc/php.ini

# 启动httpd，mysqld
systemctl start httpd
systemctl enable httpd
systemctl start mariadb
systemctl enable mariadb

# 初始化mysql数据库，并配置root用户密码
# mysqladmin -u root password ykadmin123
# mysql -uroot -pykadmin123 <<EOF
# select user, host, password from mysql.user;
# drop user ''@'localhost';
# quit
# EOF

mysql_secure_installation <<EOF

Y
ykadmin123
ykadmin123
Y
Y
Y
Y
EOF

# 创建数据库
mysql -uroot -pykadmin123 <<EOF
CREATE DATABASE zabbix character set utf8 collate utf8_bin;       
GRANT all ON zabbix.* TO 'zabbix'@'%' IDENTIFIED BY 'ykadmin123';
flush privileges;    
quit            
EOF
# < createdb.sql

# 安装zabbix
## 安装依赖包 + 组件
yum -y install net-snmp net-snmp-devel curl curl-devel libxml2 libxml2-devel libevent-devel.x86_64 javacc.noarch  javacc-javadoc.noarch javacc-maven-plugin.noarch javacc*

## 安装php支持zabbix组件
yum install php-bcmath php-mbstring -y 

# 测试LAMP是否搭建成功
echo '<?php' > /var/www/html/index.php
echo '$link=mysql_connect("127.0.0.1","zabbix","ykadmin123");' >> /var/www/html/index.php
echo 'if($link) echo "<h1>Success!!</h1>";' >> /var/www/html/index.php
echo 'else echo "Fail!!";' >> /var/www/html/index.php
echo 'mysql_close();' >> /var/www/html/index.php
echo '?>' >> /var/www/html/index.php

## 更新yum源文件，保证系统可以上网 
  
#rpm -ivh http://repo.zabbix.com/zabbix/4.3/rhel/7/x86_64/zabbix-release-4.3-3.el7.noarch.rpm
#rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/4.3/rhel/7/x86_64/zabbix-release-4.3-3.el7.noarch.rpm
cat <<EOF > /etc/yum.repos.d/zabbix.repo 
[zabbix]
name=Zabbix Official Repository - \$basearch
baseurl=https://mirrors.aliyun.com/zabbix/zabbix/4.0/rhel/7/\$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
 
[zabbix-non-supported]
name=Zabbix Official Repository non-supported - \$basearch 
baseurl=https://mirrors.aliyun.com/zabbix/non-supported/rhel/7/\$basearch/
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
gpgcheck=1
EOF
# 添加gpgkey
curl https://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX-A14FE591 \
-o /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
 
curl https://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX \
-o /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
yum makecache -y


## 安装zabbix组件 
yum install zabbix-server-mysql zabbix-web-mysql -y    
 
## 导入数据到数据库zabbix中(最后一个zabbix是数据库zabbix)，且因为用户zabbix是%(任意主机)，所以登录时需要加上当前主机ip(-h 172.18.20.224),密码是用户zabbix登陆密码ykadmin123


zcat /usr/share/doc/zabbix-server-mysql-4.0.*/create.sql.gz | mysql -uzabbix -pykadmin123 -h 127.0.0.1 zabbix   

sed -i "s/# DBPassword=/DBPassword=ykadmin123/g" /etc/zabbix/zabbix_server.conf
sed -i "s/# php_value date.timezone Europe\/Riga/php_value date.timezone Asia\/Shanghai/g" /etc/httpd/conf.d/zabbix.conf

# 启动并加入开机自启动zabbix-server

systemctl enable zabbix-server 
systemctl start zabbix-server
systemctl restart httpd

###### 错误参考 #######################
# [mysql普通用户本机无法登录的解决办法](https://www.cnblogs.com/zzliu/p/10661295.html)



########################################