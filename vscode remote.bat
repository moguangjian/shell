rem ����key��һֱ�س��Ϳ�����

ssh-keygen -t rsa -b 4096

rem ע�⣬����Ҫ������ȷ���û�����Զ�������ĵ�ַ
SET REMOTEHOST=root@192.168.1.xxx

scp %USERPROFILE%\.ssh\id_rsa.pub %REMOTEHOST%:~/tmp.pub
ssh %REMOTEHOST% "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat ~/tmp.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && rm -f ~/tmp.pub"