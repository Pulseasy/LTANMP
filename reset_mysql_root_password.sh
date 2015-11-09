#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

echo "=========================================================================\n"
printf "Reset MySQL root Password for LTANMP  ,  Written by XiaoHuai \n"
printf "=========================================================================\n"
printf "LTANMP is a tool to auto-compile & install Nginx+Tengine+MySQL+PHP on Linux \n"
printf "This script is a tool to reset mysql root password for ltanmp \n"
printf "For more information please visit http://www.ltanmp.com \n"
printf "\n"
printf "Usage: sh reset_mysql_root_password.sh\n"
printf "=========================================================================\n"

mysql_root_password=""
read -p "(Please input New MySQL root password):" mysql_root_password
if [ "$mysql_root_password" = "" ]; then
	echo "Error: Password can't be NULL!!\n"
	exit 1
fi

printf "Stoping MySQL...\n"
/etc/init.d/mysql stop
printf "Starting MySQL with skip grant tables\n"
/usr/local/mysql/bin/mysqld_safe --skip-grant-tables >/dev/null 2>&1 &
printf "using mysql to flush privileges and reset password\n"
sleep 10
printf "update user set password = Password('$mysql_root_password') where User = 'root'\n"
/usr/local/mysql/bin/mysql -u root mysql << EOF
update user set password = Password('$mysql_root_password') where User = 'root';
EOF

reset_status=`echo $?`
if [ $reset_status = "0" ]; then
printf "Password reset succesfully. Now killing mysqld softly\n"
killall mysqld
sleep 10
printf "Restarting the actual mysql service\n"
/etc/init.d/mysql start
printf "Password successfully reset to '$mysql_root_password'\n"
else
printf "Reset MySQL root password failed!\n"
fi
