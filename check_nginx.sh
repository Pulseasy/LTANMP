#!/bin/sh
nginx="/usr/local/nginx/sbin/nginx"
conf="/usr/local/nginx/conf/nginx.conf"
status=$(ps aux |grep 'nginx: worker process'|grep -v 'grep'|wc -l)
if [ $status -eq 0 ];
then
$nginx -c $conf &
else
exit 0;
fi
