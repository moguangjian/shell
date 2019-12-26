#!bin/bash
#####
#参考了：[linux centos7.2配置vsftpd之详细步骤](https://blog.csdn.net/gsl371/article/details/92632047)
# [CentOS7配置vsftpd3.0.2](https://blog.csdn.net/weixin_30686845/article/details/99867032)
#
######

# 安装
yum -y install vsftpd
systemctl start vsftpd.service

# 开放端口
firewall-cmd --zone=public --add-service=ftp --permanent 
firewall-cmd --zone=public --add-port=21/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent 
firewall-cmd --reload

# 设置selinux(如果关闭了selinux，可跳过此步骤）
# 查看ftp的状态
getsebool -a|grep ftp
# 将以下两项状态设置为on：
setsebool -P allow_ftpd_full_access on
setsebool -P tftp_home_dir on

# 关闭匿名用户
sed -i "s/anonymous_enable=YES/anonymous_enable=NO/g" /etc/vsftpd/vsftpd.conf

# 重启服务
systemctl restart  vsftpd.service

# 建立虚拟FTP用户的帐号数据库文件
## 1、编辑虚拟数据库文件 vi /etc/vsftpd/ftp.list
echo 'user1' > /etc/vsftpd/ftp.list
echo '3H%ps1oU8b' >> /etc/vsftpd/ftp.list
echo 'user2' >> /etc/vsftpd/ftp.list
echo 'wK3E!Vy1li' >> /etc/vsftpd/ftp.list
echo 'user3' >> /etc/vsftpd/ftp.list
echo 'e61LYh*M!0' >> /etc/vsftpd/ftp.list

## 2、将虚拟用户数据库文件转换为认证模块识别的数据文件
db_load -T -t hash -f /etc/vsftpd/ftp.list /etc/vsftpd/ftp.db
## 3、给虚拟用户数据库文件和认证模块识别的数据文件指定权限
chmod 600 /etc/vsftpd/ftp.*

# 创建一个虚拟用户映射的真实系统用户（宿主用户）
## 1、创建一个目录作为上传数据目录，也可以在创建用户时指定目录。
mkdir /data/

## 2、创建用户并指定家目录
useradd -d /data/ -s /sbin/nologin ftpuser

## 3、为ftpuser用户设置密码：
echo "cG&45LIkub" | passwd --stdin ftpuser

## 4、给这个用户家目录设置权限
chmod 755 /data/

## 5、将这个用户添加到vsftp的允许登录的用户组中
echo "ftpuser" >> /etc/vsftpd/user_list


# 配置pam认证模块

## 1、备份pam认证模块配置文件
cp /etc/pam.d/vsftpd /etc/pam.d/vsftpd.pam

## 2、配置pam认证模块文件 vi /etc/pam.d/vsftpd
sed -i 's/^/#/' /etc/pam.d/vsftpd
echo "auth    required  pam_userdb.so db=/etc/vsftpd/ftp
account required  pam_userdb.so db=/etc/vsftpd/ftp" >> /etc/pam.d/vsftpd
echo "" >> /etc/pam.d/vsftpd

# 配置vsftpd配置文件

## 1、备份vsftpd配置文件
cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.backup

## 2、编辑vsftpd配置文件 vi /etc/vsftpd/vsftpd.conf
rm -f /etc/vsftpd/vsftpd.conf
touch /etc/vsftpd/vsftpd.conf

echo "# Example config file /etc/vsftpd/vsftpd.conf" >> /etc/vsftpd/vsftpd.conf
echo "#" >> /etc/vsftpd/vsftpd.conf
echo "anonymous_enable=NO" >> /etc/vsftpd/vsftpd.conf
echo "local_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "write_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "local_umask=022" >> /etc/vsftpd/vsftpd.conf
echo "#" >> /etc/vsftpd/vsftpd.conf
echo "anon_upload_enable=NO" >> /etc/vsftpd/vsftpd.conf
echo "anon_mkdir_write_enable=NO" >> /etc/vsftpd/vsftpd.conf
echo "dirmessage_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "xferlog_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "connect_from_port_20=YES" >> /etc/vsftpd/vsftpd.conf
echo "xferlog_file=/var/log/xferlog" >> /etc/vsftpd/vsftpd.conf
echo "#" >> /etc/vsftpd/vsftpd.conf
echo "xferlog_std_format=YES" >> /etc/vsftpd/vsftpd.conf
echo "ascii_upload_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "ascii_download_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "  " >> /etc/vsftpd/vsftpd.conf
echo "chroot_list_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "# (default follows)" >> /etc/vsftpd/vsftpd.conf
echo "chroot_list_file=/etc/vsftpd/chroot_list" >> /etc/vsftpd/vsftpd.conf
echo "listen=YES" >> /etc/vsftpd/vsftpd.conf
echo "pam_service_name=vsftpd" >> /etc/vsftpd/vsftpd.conf
echo "userlist_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "tcp_wrappers=YES" >> /etc/vsftpd/vsftpd.conf
echo "## my add here" >> /etc/vsftpd/vsftpd.conf
echo "guest_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "guest_username=ftpuser" >> /etc/vsftpd/vsftpd.conf
echo "user_config_dir=/etc/vsftpd/dir" >> /etc/vsftpd/vsftpd.conf
echo "allow_writeable_chroot=YES" >> /etc/vsftpd/vsftpd.conf
echo "pasv_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "pasv_min_port=10030" >> /etc/vsftpd/vsftpd.conf
echo "pasv_max_port=10035" >> /etc/vsftpd/vsftpd.conf

# 创建几个不同权限的虚拟用户

## 1、创建根本目录列表文件, 有多少个虚拟用户，分别按照以上格式写在根本目录列表文件里
echo "user1" > /etc/vsftpd/chroot_list
echo "user2" > /etc/vsftpd/chroot_list
echo "user3" > /etc/vsftpd/chroot_list

## 2、创建每个虚拟用户的家目录，这里我们为user1分配file_1,user2分配file_2....
mkdir /data/file_1
mkdir /data/file_2
mkdir /data/file_1/file_3

## 3、递归更改用户家目录属性
chown -R ftpuser:ftpuser /data/


## 4、创建虚拟用户配置文件（多少用户创建多少个）

mkdir /etc/vsftpd/dir
### 1）创建user1虚拟用户配置文件 vi /etc/vsftpd/dir/user1
### 注：每个虚拟用户都从这里指定访问权限，当前user1虚拟用户拥有完全权限。

echo "local_root=/data/file_1/" > /etc/vsftpd/dir/user1
echo "#指定虚拟用户的具体主路径" >> /etc/vsftpd/dir/user1
echo "write_enable=YES" >> /etc/vsftpd/dir/user1
echo "#设定允许写操作" >> /etc/vsftpd/dir/user1
echo "anon_umask=022" >> /etc/vsftpd/dir/user1
echo "anon_world_readable_only=NO" >> /etc/vsftpd/dir/user1
echo "#local_umask=022" >> /etc/vsftpd/dir/user1
echo "#设定上传文件权限掩码" >> /etc/vsftpd/dir/user1
echo "anon_upload_enable=YES" >> /etc/vsftpd/dir/user1
echo "#设定不允许匿名用户上传" >> /etc/vsftpd/dir/user1
echo "anon_mkdir_write_enable=NO" >> /etc/vsftpd/dir/user1
echo "#设定不允许匿名用户建立目录" >> /etc/vsftpd/dir/user1
echo "anon_other_write_enable=YES" >> /etc/vsftpd/dir/user1
echo "idle_session_timeout=600" >> /etc/vsftpd/dir/user1
echo "#设定空闲连接超时时间" >> /etc/vsftpd/dir/user1
echo "data_connection_timeout=120" >> /etc/vsftpd/dir/user1
echo "#设定单次连续传输最大时间" >> /etc/vsftpd/dir/user1
echo "max_clients=10" >> /etc/vsftpd/dir/user1
echo "#设定并发客户端访问个数" >> /etc/vsftpd/dir/user1
echo "max_per_ip=5" >> /etc/vsftpd/dir/user1
echo "#设定单个客户端的最大线程数，这个配置主要来照顾Flashget、迅雷等多线程下载软件" >> /etc/vsftpd/dir/user1
echo "local_max_rate=50000" >> /etc/vsftpd/dir/user1
echo "#设定该用户的最大传输速率，单位b/s" >> /etc/vsftpd/dir/user1

### 2）创建user2虚拟用户配置文件 vi /etc/vsftpd/dir/user2
### 注：当前user2用户只用上传下载的权限。

echo "local_root=/data/file_2/" > /etc/vsftpd/dir/user2
echo "#指定虚拟用户的具体主路径" >> /etc/vsftpd/dir/user2
echo "write_enable=YES" >> /etc/vsftpd/dir/user2
echo "#设定允许写操作" >> /etc/vsftpd/dir/user2
echo "anon_umask=022" >> /etc/vsftpd/dir/user2
echo "anon_world_readable_only=NO" >> /etc/vsftpd/dir/user2
echo "#local_umask=022" >> /etc/vsftpd/dir/user2
echo "#设定上传文件权限掩码" >> /etc/vsftpd/dir/user2
echo "anon_upload_enable=YES" >> /etc/vsftpd/dir/user2
echo "#设定不允许匿名用户上传" >> /etc/vsftpd/dir/user2
echo "anon_mkdir_write_enable=YES" >> /etc/vsftpd/dir/user2
echo "#设定不允许匿名用户建立目录" >> /etc/vsftpd/dir/user2
echo "#anon_other_write_enable=YES" >> /etc/vsftpd/dir/user2
echo "idle_session_timeout=600" >> /etc/vsftpd/dir/user2
echo "#设定空闲连接超时时间" >> /etc/vsftpd/dir/user2
echo "data_connection_timeout=120" >> /etc/vsftpd/dir/user2
echo "#设定单次连续传输最大时间" >> /etc/vsftpd/dir/user2
echo "max_clients=10" >> /etc/vsftpd/dir/user2
echo "#设定并发客户端访问个数" >> /etc/vsftpd/dir/user2
echo "max_per_ip=5" >> /etc/vsftpd/dir/user2
echo "#设定单个客户端的最大线程数，这个配置主要来照顾Flashget、迅雷等多线程下载软件" >> /etc/vsftpd/dir/user2
echo "local_max_rate=50000" >> /etc/vsftpd/dir/user2
echo "#设定该用户的最大传输速率，单位b/s" >> /etc/vsftpd/dir/user2

### 3）创建user3虚拟用户配置文件 vi /etc/vsftpd/dir/user3
### 注：当前user3用户只有上传和下载和创建目录的权限，无其他权限。

echo "local_root=/data/file_1/file_3" > /etc/vsftpd/dir/user3
echo "#指定虚拟用户的具体主路径" >> /etc/vsftpd/dir/user3
echo "write_enable=YES" >> /etc/vsftpd/dir/user3
echo "#设定允许写操作" >> /etc/vsftpd/dir/user3
echo "anon_umask=022" >> /etc/vsftpd/dir/user3
echo "anon_world_readable_only=NO" >> /etc/vsftpd/dir/user3
echo "#local_umask=022" >> /etc/vsftpd/dir/user3
echo "#设定上传文件权限掩码" >> /etc/vsftpd/dir/user3
echo "anon_upload_enable=YES" >> /etc/vsftpd/dir/user3
echo "#设定不允许匿名用户上传" >> /etc/vsftpd/dir/user3
echo "#anon_mkdir_write_enable=NO" >> /etc/vsftpd/dir/user3
echo "#设定不允许匿名用户建立目录" >> /etc/vsftpd/dir/user3
echo "#anon_other_write_enable=YES" >> /etc/vsftpd/dir/user3
echo "idle_session_timeout=600" >> /etc/vsftpd/dir/user3
echo "#设定空闲连接超时时间" >> /etc/vsftpd/dir/user3
echo "data_connection_timeout=120" >> /etc/vsftpd/dir/user3
echo "#设定单次连续传输最大时间" >> /etc/vsftpd/dir/user3
echo "max_clients=10" >> /etc/vsftpd/dir/user3
echo "#设定并发客户端访问个数" >> /etc/vsftpd/dir/user3
echo "max_per_ip=5" >> /etc/vsftpd/dir/user3
echo "#设定单个客户端的最大线程数，这个配置主要来照顾Flashget、迅雷等多线程下载软件" >> /etc/vsftpd/dir/user3
echo "local_max_rate=50000" >> /etc/vsftpd/dir/user3
echo "#设定该用户的最大传输速率，单位b/s" >> /etc/vsftpd/dir/user3

# 重启vsftpd服务，使配置生效
systemctl restart vsftpd

# 查看监听端口 
netstat -antupl | grep vsftpd