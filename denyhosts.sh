#!/bin/bash
cd /usr/local/src
wget http://jaist.dl.sourceforge.net/sourceforge/denyhosts/DenyHosts-2.6.tar.gz
tar zxf DenyHosts-2.6.tar.gz
cd DenyHosts-2.6
python setup.py install
cd /usr/share/denyhosts/
cp daemon-control-dist daemon-control
chown root daemon-control
chmod 700 daemon-control
grep -v "^#" denyhosts.cfg-dist > denyhosts.cfg
cat >/usr/share/denyhosts/denyhosts.cfg<<eof
       ############ THESE SETTINGS ARE REQUIRED ############

SECURE_LOG = /var/log/secure
HOSTS_DENY = /etc/hosts.deny
#过多久后清除
PURGE_DENY = 30m
#阻止服务名
BLOCK_SERVICE  = sshd
#允许无效用户（/etc/passwd未列出）登录失败的次数
DENY_THRESHOLD_INVALID = 1
#允许有效（普通）用户登录失败的次数
DENY_THRESHOLD_VALID = 10
#允许root登录失败的次数
DENY_THRESHOLD_ROOT = 5
#设定 deny host 写入到该资料夹
DENY_THRESHOLD_RESTRICTED = 1
#运行目录
WORK_DIR = /usr/share/denyhosts/data

SUSPICIOUS_LOGIN_REPORT_ALLOWED_HOSTS=YES
#是否做域名反解
HOSTNAME_LOOKUP=YES
#将DenyHOts启动的pid纪录到LOCK_FILE中，已确保服务正确启动，防止同时启动多个服务
LOCK_FILE = /var/lock/subsys/denyhosts


       ############ THESE SETTINGS ARE OPTIONAL ############

#设置管理员邮件
ADMIN_EMAIL = root
SMTP_HOST = localhost
SMTP_PORT = 25
SMTP_FROM = DenyHosts <nobody@localhost>
SMTP_SUBJECT = DenyHosts Report
#多长时间后，用户登录失败的次数被置为0，这里是指在/etc/passwd里面定义的用户，如果不设置，永远都不会置0 
AGE_RESET_VALID=5d
#多长时间后，root用户登录失败的次数置为0，如果不设置，永远都不会置0 
AGE_RESET_ROOT=25d
#在$WORK_DIR/hosts-restricted时面定义的用户，多长时间失败次数计数器被置为0 
AGE_RESET_RESTRICTED=25d
#无效用户(不在/etc/passwd里面的用户)的失败次数计数器，多长时间被置为0 
AGE_RESET_INVALID=10d
#当某个IP使用某个用户登录成功后，该IP对应的用户失败次数将会被置为0
RESET_ON_SUCCESS = yes
   ######### THESE SETTINGS ARE SPECIFIC TO DAEMON MODE  ##########

DAEMON_LOG = /var/log/denyhosts
DAEMON_SLEEP = 30s
DAEMON_PURGE = 30m
#当登录成功时，把登录成功的失败计数重置为0。默认是 NO。
RESET_ON_SUCCESS = yes
   #########   THESE SETTINGS ARE SPECIFIC TO     ##########
   #########       DAEMON SYNCHRONIZATION         ##########
eof
echo "/usr/share/denyhosts/daemon-control start" >>/etc/rc.local
cd /etc/init.d
ln -s /usr/share/denyhosts/daemon-control denyhosts
chkconfig --add denyhosts
chkconfig --level 345 denyhosts on
service denyhosts start
