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
echo "Upgrade Mysql for LTANMP,  Written by xiaohuai"
echo "========================================================================="
echo "LTANMP is tool to auto-compile & install Tengine+Nginx+MySQL+PHP on Linux "
echo ""
echo "For more LTMP information please visit http://www.ltanmp.com/"
echo "========================================================================="

nv=`mysql --version 2>&1`
old_mysql_version=`echo $nv | awk -F'[ ,]' '{print $6}'`
#echo $old_mysql_version

if [ "$1" != "--help" ]; then

#set mysql version

	mysql_version=""
	echo "Current mysql Version:$nv"
	echo "You can get version number from http://www.mysql.com/downloads/mysql/"
	read -p "(example: 5.5.19 ):" mysql_version
	if [ "$mysql_version" = "" ]; then
		echo "Error: You must input mysql version!!"
		exit 1
	fi
	echo "==========================="

	echo "You want to upgrade mysql version to $mysql_version"

	echo "==========================="

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
	echo "Press any key to start...or Press Ctrl+c to cancel"
	char=`get_char`

echo "============================check files=================================="
wget -c http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-$mysql_version.tar.gz

if [ -s mysql-$mysql_version.tar.gz ]; then
  echo "mysql-$mysql_version.tar.gz [found]"
  else
  echo "Error: mysql-$mysql_version.tar.gz not found!!!download now......"
  wget http://cdn.mysql.com/Downloads/MySQL-5.5/mysql-$mysql_version.tar.gz
  dl_status=`echo $?`
  if [ $dl_status = "0" ]; then
	echo "Download mysql-$mysql_version.tar.gz successfully!"
  else
	echo "WARNING!May be the mysql version you input was wrong,please check!"
	echo "mysql Version input was:"$mysql_version
	sleep 5
	exit 1
  fi
fi

if [ -s /usr/local/bin/cmake -o -s /usr/bin/cmake ]; then
  echo "cmake [found]"
  else
  echo "Error: cmake not found!!! install now....."
  wget -c http://www.cmake.org/files/v2.8/cmake-2.8.10.2.tar.gz
	
	tar zxvf cmake-2.8.10.2.tar.gz
	cd cmake-2.8.10.2/
	./configure
	make
	make install
	cd ../
	if [ -s /usr/bin/cmake ]; then
		echo "Install cmake successfully!"
	else
		echo "Congratulation, you have finished installing cmake and starts to update MySQL..."
   sleep 5
	fi
fi
echo "============================cmake install successful======================="

echo "============================install mysql=================================="
rm -rf mysql-$mysql_version

tar zxvf mysql-$mysql_version.tar.gz
cd mysql-$mysql_version/
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_READLINE=1 -DWITH_SSL=system -DWITH_EMBEDDED_SERVER=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_PERFSCHEMA_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_FEDERATEDX_STORAGE_ENGINE=1 -DWITH_ARIA_STORAGE_ENGINE=1 -DWITH_XTRADB_STORAGE_ENGINE=1 -DWITH_EXTRA_CHARSETS=all -DWITH_LIBWRAP=1  -DWITH_ZLIB=system -DENABLED_LOCAL_INFILE=1
make
/etc/init.d/mysql stop
mv /usr/local/mysql/ /usr/local/mysql.old
make install
if [ -d /usr/local/mysql.old/var ]; then
cp -a /usr/local/mysql.old/var/* /usr/local/mysql/data
else
cp -a /usr/local/mysql.old/data/* /usr/local/mysql/data
fi
chown -R mysql.mysql /usr/local/mysql/data
chgrp -R mysql /usr/local/mysql/.
mv /etc/init.d/mysql /etc/init.d/mysql.old -f
cp support-files/mysql.server /etc/init.d/mysql
chmod 755 /etc/init.d/mysql

cat > /etc/ld.so.conf.d/mysql.conf<<EOF
/usr/local/mysql/lib
/usr/local/lib
EOF
ldconfig

rm -f /usr/lib/mysql
rm -f /usr/include/mysql
rm -f /usr/bin/mysql
rm -f /usr/bin/myisamchk
rm -f /usr/bin/mysqldump

ln -s /usr/local/mysql/lib/mysql /usr/lib/mysql
ln -s /usr/local/mysql/include/mysql /usr/include/mysql

ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk

/etc/init.d/mysql start
pid=`ps -ef|grep mysqld_safe|grep -v grep|awk '{print $2}'`
if [ "$pid" == "" ]; then
	echo "Error Insatll Mysql...."
	cd ..
	sleep 5
	exit 1
fi
echo "Upgrade completed!"
echo "Program will display Mysql Version......"
mysql --version
cd ../
sleep 5

chown -R mysql:mysql /usr/local/mysql/data
/usr/local/mysql/bin/mysql_upgrade -u root -p
if [ -f /usr/local/mysql/bin/mysqld_safe ];then
sed -i '/export LD_PRELOAD=/d' /usr/local/mysql/bin/mysqld_safe
sed -i '/executing mysqld_safe'/a\ "export LD_PRELOAD=\/usr\/local\/lib\/libtcmalloc.so" /usr/local/mysql/bin/mysqld_safe
fi
echo "========================================================================="
echo "You have successfully upgrade from $nv to mysql-$mysql_version"
echo "========================================================================="
echo "LTANMP is tool to auto-compile & install Tengine+Nginx+MySQL+PHP on Linux "
echo "========================================================================="
echo ""
echo "For more information please visit http://www.ltanmp.com/"
echo ""
echo "========================================================================="
fi
