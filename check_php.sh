#!/bin/sh
#nginx="/usr/local/nginx/sbin/nginx"
#conf="/usr/local/nginx/conf/nginx.conf"
status=$(ps aux |grep 'php-fpm: pool www'|grep -v 'grep'|wc -l)
if [ $status -eq 0 ];
then
/etc/init.d/php-fpm restart &
else
exit 0;
fi
