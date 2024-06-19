#!/bin/sh
#
#安装好了之后删除此文件，
#以及 ./app/ofelia/config.ini 对应的定时任务
#
#判断phpMyAdmin目录是否存在
if [ ! -d /www/default/phpMyAdmin ];then
    composer create-project phpmyadmin/phpmyadmin /www/default/phpMyAdmin \
	&& cp /www/default/phpMyAdmin/config.sample.inc.php /www/default/phpMyAdmin/config.inc.php \
	&& sed -i "s/localhost/mariadb/g" /www/default/phpMyAdmin/config.inc.php
fi

#判断phpRedisAdmin目录是否存在
if [ ! -d /www/default/phpRedisAdmin ];then
    composer create-project -s dev erik-dubbelboer/php-redis-admin /www/default/phpRedisAdmin \
	&& cp /www/default/phpRedisAdmin/includes/config.sample.inc.php /www/default/phpRedisAdmin/includes/config.inc.php \
	&& sed -i "s/127.0.0.1/kvrocks/g" /www/default/phpRedisAdmin/includes/config.inc.php \
	&& sed -i "s/6379/6666/g" /www/default/phpRedisAdmin/includes/config.inc.php
fi

echo "OK"
