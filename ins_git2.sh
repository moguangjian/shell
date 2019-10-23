#!/bin/bash
# 本脚本用于安装git 2.7 服务
cd /usr/src
yum -y install gcc-c++ openssl-devel curl-devel expat-devel libcurl-dev libcurl-devell wget perl-ExtUtils-MakeMaker package lftp
# systemctl restart httpd
# wget https://Github.com/Git/Git/archive/v2.7.3.tar.gz
lftp -c "pget -n 10 https://Github.com/Git/Git/archive/v2.7.3.tar.gz"
tar xzf v2.7.3.tar.gz
cd git-2.7.3
make prefix=/usr/local/git all
make prefix=/usr/local/git install
# 创建软连接
rm /usr/bin/git -f
cd /usr/bin
ln -s  /usr/local/git/bin/git git
