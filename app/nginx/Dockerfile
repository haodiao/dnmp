ARG NGINX_VERSION
FROM $NGINX_VERSION

ARG TZ
ARG NGINX_VERSION
ARG CONTAINER_PACKAGE_URL

RUN if [ "${CONTAINER_PACKAGE_URL}" != "" ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

WORKDIR /www
