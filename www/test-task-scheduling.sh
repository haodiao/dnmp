#!/bin/sh
#
#安装好了之后删除此文件，
#以及 ./app/ofelia/config.ini 对应的定时任务
#
#判断phpMyAdmin目录是否存在
if [ ! -d /www/default/phpMyAdmin ];then
    composer create-project phpmyadmin/phpmyadmin /www/default/phpMyAdmin
fi

#判断phpRedisAdmin目录是否存在
if [ ! -d /www/default/phpRedisAdmin ];then
    composer create-project -s dev erik-dubbelboer/php-redis-admin /www/default/phpRedisAdmin
fi

echo "OK"
