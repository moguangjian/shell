#!/bin/bash

# 先安装一些依赖
yum -y install zlib-devel bzip2-devel openssl-devel openssl-static ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel lzma gcc
yum -y groupinstall "Development tools"

version=3.7.5
cd /usr/local/src/

# lftp -c "pget -n 10 https://www.python.org/ftp/python/$version/Python-$version.tar.xz"
lftp -c "pget -n 10 https://npm.taobao.org/mirrors/python/$version/Python-$version.tar.xz"

tar xvf Python-$version.tar.xz
cd /usr/local/src/Python-$version
./configure --prefix=/usr/local/sbin/python-3.7
make && make install

rm -f /usr/bin/python  
rm -f /usr/bin/pip  
ln -s /usr/local/sbin/python-3.7/bin/python3.7 /usr/bin/python 
ln -s /usr/local/sbin/python-3.7/bin/pip3.7 /usr/bin/pip 
pip install --no-cache-dir --upgrade pip -i https://pypi.douban.com/simple  
if ! grep "python2" /usr/bin/yum  >/dev/null 2>&1;then
    sed -i 's/python/python2.7/' /usr/bin/yum
fi
if ! grep "python2" /usr/bin/yum-builddep  >/dev/null 2>&1;then
    sed -i 's/python/python2.7/' /usr/bin/yum-builddep
fi
if ! grep "python2" /usr/bin/yum-config-manager  >/dev/null 2>&1;then
    sed -i 's/python/python2.7/' /usr/bin/yum-config-manager
fi
if ! grep "python2" /usr/bin/yum-debug-dump  >/dev/null 2>&1;then
    sed -i 's/python/python2.7/' /usr/bin/yum-debug-dump
fi
if ! grep "python2" /usr/bin/yum-debug-restore  >/dev/null 2>&1;then
    sed -i 's/python/python2.7/' /usr/bin/yum-debug-restore
fi
if ! grep "python2" /usr/bin/yum-groups-manager  >/dev/null 2>&1;then
    sed -i 's/python/python2.7/' /usr/bin/yum-groups-manager
fi
if ! grep "python2" /usr/bin/yumdownloader  >/dev/null 2>&1;then
    sed -i 's/python/python2.7/' /usr/bin/yumdownloader
fi
if ! grep "python2" /usr/libexec/urlgrabber-ext-down  >/dev/null 2>&1;then
    sed -i 's/python/python2.7/' /usr/libexec/urlgrabber-ext-down
fi
# 防火墙的设置
if ! grep "python2" /usr/bin/firewall-cmd  >/dev/null 2>&1;then
    sed -i 's/python/python2.7/' /usr/bin/firewall-cmd
fi
if ! grep "python2" /usr/sbin/firewalld  >/dev/null 2>&1;then
    sed -i 's/python/python2.7/' /usr/sbin/firewalld
fi
yum clean all
