#!/bin/sh

echo 
echo "+++++++++++++++++++++++++++++++++++++++++++++"
echo "PHP version               : ${PHP_VERSION}"
echo "Extra Extensions          : ${PHP_EXTENSIONS}"
echo "Container package url     : ${CONTAINER_PACKAGE_URL}"
echo "+++++++++++++++++++++++++++++++++++++++++++++"
echo 

# PHP拓展安装方法
installPHPExtensions() {
    # 初始化需安装的拓展
    installExts=

    # 遍历参数里的拓展
    for ext; do
        if [ 1 -eq `php -m | grep ${ext} | wc -l` ]; then
            echo "${ext} was already installed"
            continue
        fi

		# 处理有特殊要求的拓展
		if [ "swoole" = ${ext} ]; then
			# apk add --no-cache sqlite
			apk add --no-cache sqlite-dev
			# swoole的安装参数请根据自己需求设置
			pecl install -D 'enable-sockets="yes" enable-openssl="yes" enable-http2="yes" enable-mysqlnd="yes" enable-swoole-json="yes" enable-swoole-curl="yes" enable-cares="yes" enable-brotli="yes" enable-swoole-sqlite="no" enable-swoole-pgsql="no" with-swoole-odbc="no" with-swoole-oracle="no"' swoole
			docker-php-ext-enable swoole
			continue
		fi

		# imagick 还没有支持 PHP8.3 的正式版，暂时安装开发版
		if [ "imagick" = ${extName} ]; then
			if [ $(php -r 'echo PHP_VERSION_ID;') -ge 80300 ]; then
			# PHP8.3 不适用于 alpine3.19 ，暂时注释
			# ext="https://api.github.com/repos/Imagick/imagick/tarball/28f27044e435a2b203e32675e942eb8de620ee58";
			# PHP8.3 暂时改为3.6版本
			ext=imagick-3.6.0
			fi
		fi

        installExts="$installExts $ext"
    done

    # 检查需安装的拓展
    if [ -z "${installExts}" ]; then
        echo "---------- No More Extensions To Install ----------"
        return 0;
    fi

    # 安装拓展
	install-php-extensions ${installExts}
}

installPHPExtensions ${PHP_EXTENSIONS//,/ }
