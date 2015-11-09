Mem=`free -m | awk '/Mem:/{print $2}'` #我的机器内存是987M
php_install_dir='/usr/local/php/'
sed -i "s@^pm.max_children.*@pm.max_children = $(($Mem/2/20))@" $php_install_dir/etc/php-fpm.conf
sed -i "s@^pm.start_servers.*@pm.start_servers = $(($Mem/2/30))@" $php_install_dir/etc/php-fpm.conf
sed -i "s@^pm.min_spare_servers.*@pm.min_spare_servers = $(($Mem/2/40))@" $php_install_dir/etc/php-fpm.conf
sed -i "s@^pm.max_spare_servers.*@pm.max_spare_servers = $(($Mem/2/20))@" $php_install_dir/etc/php-fpm.conf
/etc/init.d/php-fpm restart
