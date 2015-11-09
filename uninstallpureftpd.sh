#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

if [ $(id -u) != "0" ]; then
	printf "Error: You must be root to run this script!"
	exit 1
fi

clear
printf "=========================================================================\n"
printf "Pureftpd Auto Uninstall Shell Scritp  ,  Written by xiaohuai \n"
printf "=========================================================================\n"
printf "LTANMP is a tool to auto-compile & install Tengine+Nginx+MySQL+PHP on Linux \n"
printf "This script is a tool to Uninstall pureftpd for ltanmp \n"
printf "\n"
printf "For more information please visit http://www.ltanmp.com \n"
printf "\n"
printf "Usage: ./uninstallpureftpd.sh \n"
printf "=========================================================================\n"

echo "Are you sure uninstall Pureftpd? (y/n)"
read -p "(Default: n):" UNINSTALL
if [ -z $UNINSTALL ]; then
	UNINSTALL="n"
fi
if [ "$UNINSTALL" != "y" ]; then
	clear
	echo "==========================="
	echo "You canceled the uninstall!"
	echo "==========================="
	exit
else
	echo "---------------------------"
	echo "Yes, I decided to uninstall!"
	echo "---------------------------"
	echo ""
fi

echo ""
read -p "Please enter the root password of MySQL:" MYSQL_ROOT_PWD
if [ -z $MYSQL_ROOT_PWD ]; then
	MYSQL_ROOT_PWD=""
fi
echo "---------------------------"
echo "MySQL root password = $MYSQL_ROOT_PWD"
echo "---------------------------"
echo ""

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
echo "Press any key to start uninstall Pure-FTPd...Or Ctrl+C cancel and exit ?"
echo ""
char=`get_char`

if [ "$UNINSTALL" = 'y' ]; then

	echo "---------- Pureftpd ----------"

	if cat /proc/version | grep -Eqi '(redhat|centos)';then
		chkconfig pureftpd off
	elif cat /proc/version | grep -Eqi '(debian|ubuntu)';then
		update-rc.d -f pureftpd remove
	fi

	rm -rf /usr/local/pureftpd
	rm -rf /home/www/default/ftp
	rm -rf /etc/init.d/pureftpd
	rm -rf /root/pureftpd

	echo "---------- MySQL ----------"

	mysql -uroot -p$MYSQL_ROOT_PWD -e"drop database pureftpd;Drop USER pureftpd@localhost;"

	clear
	echo "==========================="
	echo "Uninstall completed!"
	echo "For more information please visit http://www.ltanmp.com"
	echo "==========================="
fi
