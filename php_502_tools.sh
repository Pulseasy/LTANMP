 #!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install ltanmp"
    exit 1
fi


clear
echo "========================================================================="
echo "Upgrade php-fpm files,  Written by www.ltanmp.com"
echo "========================================================================="
  
cur_dir=$(pwd)
  


if [ -s /etc/init.d/httpd ] && [ -s /usr/local/apache ]; then
echo "LNMPA Can't Upgrade php-fpm file..... Need LNMP....."
exit 1
fi


now_php_version=`php -r 'echo PHP_VERSION;'`
echo $now_php_version | grep '5.2.*'
if [ $? -eq 0 ]; then
echo "PHP 5.2.* Can't Upgrade php-fpm file...... "
exit 1
fi



	ver="256"
	echo "Which version do you want to install:"
	echo "Install in  VPS <=  RAM256 M      please type: 256"
	echo "Install in  VPS <>  RAM512 M      please type: 512"
	echo "Install in  VPS <>  RAM1000M      please type: 1000"
  echo "Install in  VPS <>  RAM2000M      please type: 2000"
  echo "Install in  VPS <>  RAM4000M      please type: 4000"
  echo "Install in  VPS =>  RAM8000M      please type: 8000"
	read -p "Type 256 or 512 or  1000 or 2000 or 4000 or 8000 (Default version 256):" ver

	if [ "$ver" = "" ]; then
		ver="256"
	fi


	if [ "$ver" != 256 ] && [ "$ver" != 512 ] && [ "$ver" != 1000 ] && [ "$ver" != 2000 ] && [ "$ver" != 4000 ] && [ "$ver" != 8000 ]; then
        echo ""
	echo "Error: You must input  256 or 512 or  1000 or 2000 or 4000 or 8000 !!"
	exit 1
	fi


	get_char()
	{
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
	}

       echo ""
       echo "You will install "$ver"M VPS php-fpm files"
	echo "Press any key to start install "$ver"M VPS ...or Press Ctrl+c to cancel"

char=`get_char`


#Backup old php-fpm files
echo ""
echo "Backup old php-fpm files to /root ......"
echo ""
cp /usr/local/php/etc/php-fpm.conf /root/php-fpm.conf.old.bak



if [ "$ver" = "256" ]; then
echo "Creating new "$ver"M VPS  php-fpm  file......"
cat >/usr/local/php/etc/php-fpm.conf<<EOF
[global]
pid = /usr/local/php/var/run/php-fpm.pid
error_log = /usr/local/php/var/log/php-fpm.log
log_level = notice

[www]
listen = /tmp/php-cgi.sock
listen.backlog = -1
listen.owner = www
listen.group = www
listen.mode = 0666
user = www
group = www
pm = dynamic
pm.max_children = 10
pm.start_servers = 2
pm.min_spare_servers = 2
pm.max_spare_servers = 4
pm.max_requests = 2048
request_terminate_timeout = 180
pm.process_idle_timeout = 10
EOF

fi


if [ "$ver" = "512" ]; then

echo "Creating new "$ver"M VPS php-fpm  file......"
cat >/usr/local/php/etc/php-fpm.conf<<EOF
[global]
pid = /usr/local/php/var/run/php-fpm.pid
error_log = /usr/local/php/var/log/php-fpm.log
log_level = notice

[www]
listen = /tmp/php-cgi.sock
listen.backlog = -1
listen.owner = www
listen.group = www
listen.mode = 0666
user = www
group = www
pm = dynamic
pm.max_children = 15
pm.start_servers = 4
pm.min_spare_servers = 4
pm.max_spare_servers = 8
pm.max_requests = 2048
request_terminate_timeout = 180
pm.process_idle_timeout = 10
EOF

fi


if [ "$ver" = "1000" ]; then

echo "Creating new "$ver"M VPS php-fpm  file......"
cat >/usr/local/php/etc/php-fpm.conf<<EOF
[global]
pid = /usr/local/php/var/run/php-fpm.pid
error_log = /usr/local/php/var/log/php-fpm.log
log_level = notice

[www]
listen = /tmp/php-cgi.sock
listen.backlog = -1
listen.owner = www
listen.group = www
listen.mode = 0666
user = www
group = www
pm = dynamic
pm.max_children = 30
pm.start_servers = 8
pm.min_spare_servers = 8
pm.max_spare_servers = 15
pm.max_requests = 2048
request_terminate_timeout = 180
pm.process_idle_timeout = 10
EOF

fi

if [ "$ver" = "2000" ]; then

echo "Creating new "$ver"M VPS php-fpm  file......"
cat >/usr/local/php/etc/php-fpm.conf<<EOF
[global]
pid = /usr/local/php/var/run/php-fpm.pid
error_log = /usr/local/php/var/log/php-fpm.log
log_level = notice

[www]
listen = /tmp/php-cgi.sock
listen.backlog = -1
listen.owner = www
listen.group = www
listen.mode = 0666
user = www
group = www
pm = dynamic
pm.max_children = 60
pm.start_servers = 16
pm.min_spare_servers = 16
pm.max_spare_servers = 25
pm.max_requests = 2048
request_terminate_timeout = 180
pm.process_idle_timeout = 10
EOF

fi

if [ "$ver" = "4000" ]; then

echo "Creating new "$ver"M VPS php-fpm  file......"
cat >/usr/local/php/etc/php-fpm.conf<<EOF
[global]
pid = /usr/local/php/var/run/php-fpm.pid
error_log = /usr/local/php/var/log/php-fpm.log
log_level = notice

[www]
listen = /tmp/php-cgi.sock
listen.backlog = -1
listen.owner = www
listen.group = www
listen.mode = 0666
user = www
group = www
pm = dynamic
pm.max_children = 120
pm.start_servers = 16
pm.min_spare_servers = 16
pm.max_spare_servers = 50
pm.max_requests = 2048
request_terminate_timeout = 180
pm.process_idle_timeout = 10
EOF

fi

if [ "$ver" = "8000" ]; then

echo "Creating new "$ver"M VPS php-fpm  file......"
cat >/usr/local/php/etc/php-fpm.conf<<EOF
[global]
pid = /usr/local/php/var/run/php-fpm.pid
error_log = /usr/local/php/var/log/php-fpm.log
log_level = notice

[www]
listen = /tmp/php-cgi.sock
listen.backlog = -1
listen.owner = www
listen.group = www
listen.mode = 0666
user = www
group = www
pm = dynamic
pm.max_children = 200
pm.start_servers = 16
pm.min_spare_servers = 16
pm.max_spare_servers = 80
pm.max_requests = 2048
request_terminate_timeout = 180
pm.process_idle_timeout = 10
EOF

fi


/etc/init.d/php-fpm restart

echo ""
printf "============== Upgrade "$ver"M VPS php-fpm files  completed ===============\n"
echo ""
echo "please feedback from Forum : http://www.ltanmp.com"
echo ""
echo "========================================================================="