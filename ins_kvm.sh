#!/bin/bash
####
# 本脚本用于安装kvm
# 有以下几点需要注意，并根据自己的配置进行修改
# 一、第30行、37行的物理网卡名称需要与自己的配置一致。
# 二、
####

# 关闭selinux，重启后才能生效
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config


# 关闭防火墙
systemctl stop firewalld
systemctl disable firewalld

# 关闭iptables
systemctl stop iptables
systemctl disable iptables

# 安装kvm软件包
yum install -y virt-* qemu-kvm libvirt bridge-utils qemu-kvm-tools  net-tools

# 启动libvirtd
systemctl start libvirtd
systemctl enable libvirtd

# 配置网卡
nicname=ens33

## 备份物理网卡ens33的配置信息
cp /etc/sysconfig/network-scripts/ifcfg-$nicname ~/$nicname.bak
cp /etc/sysconfig/network-scripts/ifcfg-$nicname /etc/sysconfig/network-scripts/ifcfg-br0
sed -i "s/TYPE=Ethernet/TYPE=Bridge/g" /etc/sysconfig/network-scripts/ifcfg-br0
sed -i "s/NAME=$nicname/NAME=br0/g" /etc/sysconfig/network-scripts/ifcfg-br0
sed -i "s/DEVICE=$nicname/DEVICE=br0/g" /etc/sysconfig/network-scripts/ifcfg-br0
sed -i "s/^UUID=.*//g" /etc/sysconfig/network-scripts/ifcfg-br0

# sed -i '1 BRIDGE="br0"' /etc/sysconfig/network-scripts/ifcfg-$nicname
sed -i "s/^IPADDR=.*//g" /etc/sysconfig/network-scripts/ifcfg-$nicname
sed -i "s/^PREFIX=.*//g" /etc/sysconfig/network-scripts/ifcfg-$nicname
sed -i "s/^GATEWAY=.*//g" /etc/sysconfig/network-scripts/ifcfg-$nicname
sed -i "s/^DNS1=.*//g" /etc/sysconfig/network-scripts/ifcfg-$nicname
sed -i "s/^DNS2=.*//g" /etc/sysconfig/network-scripts/ifcfg-$nicname
sed -i '/^ *$/d' /etc/sysconfig/network-scripts/ifcfg-$nicname
echo 'BRIDGE="br0"' >> /etc/sysconfig/network-scripts/ifcfg-$nicname

systemctl restart network

# ping www.sina.com.cn


