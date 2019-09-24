cd /usr/src
yum -y install curl-devel wget
wget https://Github.com/Git/Git/archive/v2.7.3.tar.gz
tar xzf git-2.7.3.tar.gz
cd git-2.7.3
make prefix=/usr/local/git all
make prefix=/usr/local/git install
# 创建软连接
rm /usr/bin/git -f
cd /usr/bin
ln -s  /usr/local/git/bin/git git