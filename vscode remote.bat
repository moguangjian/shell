rem 创建key，一直回车就可以了

ssh-keygen -t rsa -b 4096

rem 注意，这里要输入正确的用户名和远程主机的地址
SET REMOTEHOST=root@192.168.1.xxx

scp %USERPROFILE%\.ssh\id_rsa.pub %REMOTEHOST%:~/tmp.pub
ssh %REMOTEHOST% "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat ~/tmp.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && rm -f ~/tmp.pub"