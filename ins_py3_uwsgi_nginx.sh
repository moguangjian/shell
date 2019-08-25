#!/bin/bash
# 本脚本用于安装pytthon3 、uwsgi、nginx

# 更新源
yum install -y epel-release 
yum install -y https://centos7.iuscommunity.org/ius-release.rpm 
yum clean all 
yum makecache 
yum -y upgrade 

yum-builddep -y python 
yum install -y python36u  
yum install -y python36u-devel  
yum install -y python36u-pip      
rm -f /usr/bin/python  
rm -f /usr/bin/pip  
ln -s /bin/python3.6 /usr/bin/python 
ln -s /bin/pip3.6 /usr/bin/pip 
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
#sed -i 's/python/python2.7/' /usr/bin/yum  
#sed -i 's/python/python2.7/' /usr/bin/yum-builddep  
#sed -i 's/python/python2.7/' /usr/bin/yum-config-manager 
#sed -i 's/python/python2.7/' /usr/bin/yum-debug-dump 
#sed -i 's/python/python2.7/' /usr/bin/yum-debug-restore 
#sed -i 's/python/python2.7/' /usr/bin/yum-groups-manager 
#sed -i 's/python/python2.7/' /usr/bin/yumdownloader 
#sed -i 's/python/python2.7/' /usr/libexec/urlgrabber-ext-down 

pip install --no-cache-dir uwsgi -i https://pypi.douban.com/simple
yum install nginx -y 
yum clean all