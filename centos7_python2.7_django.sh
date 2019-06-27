# 参考了 https://www.jianshu.com/p/6792d79ccdb0
# https://www.cnblogs.com/river2005/p/6813618.html
# https://blog.csdn.net/weixin_34138377/article/details/92661357


# 安装epel扩展源
yum -y install epel-release

# 安装pip
yum -y install python-pip
pip install --upgrade pip -i https://pypi.douban.com/simple
pip install django==1.8.7 -i https://pypi.douban.com/simple

# 安装虚拟环境并进行设置
pip install virtualenv virtualenvwrapper -i https://pypi.douban.com/simple

cd / && mkdir .virtualenvs
echo 'export WORKON_HOME=/.virtualenvs' >> ~/.bashrc
echo 'source /usr/bin/virtualenvwrapper.sh' >> ~/.bashrc

source ~/.bashrc 

mkvirtualenv --python=/usr/bin/python2.7  myenv 

yum -y install mariadb mariadb-server
yum -y install MySQL-python mariadb-devel

# 启动mariadb
systemctl start mariadb.service
# 设置mariadb为服务启动
systemctl enable mariadb.service

# 设置mariadb的root用户密码
mysql_secure_installation

