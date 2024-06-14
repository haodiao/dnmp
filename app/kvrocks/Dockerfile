ARG KVROCKS_VERSION
ARG TZ

FROM alpine:3.16 as build

ARG MORE_BUILD_ARGS
ARG CONTAINER_PACKAGE_URL

RUN if [ "${CONTAINER_PACKAGE_URL}" != "" ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

RUN apk update && apk upgrade && apk add git gcc g++ make cmake ninja autoconf automake libtool python3 linux-headers curl openssl-dev libexecinfo-dev redis

WORKDIR /kvrocks

RUN git clone --depth 1 https://github.com/apache/kvrocks.git /kvrocks
RUN ./x.py build -DENABLE_OPENSSL=ON -DPORTABLE=1 -DCMAKE_BUILD_TYPE=Release -j $(nproc) $MORE_BUILD_ARGS

FROM alpine:3.16

RUN apk update && apk upgrade && apk add libexecinfo
RUN mkdir /var/run/kvrocks

VOLUME /var/lib/kvrocks

COPY --from=build /kvrocks/build/kvrocks /bin/
COPY --from=build /usr/bin/redis-cli /bin/

HEALTHCHECK --interval=10s --timeout=1s --start-period=30s --retries=3 \
    CMD ./bin/redis-cli -p 6666 PING | grep -E '(PONG|NOAUTH)' || exit 1

#COPY ./LICENSE ./NOTICE ./licenses /kvrocks/
#COPY ./kvrocks.conf /var/lib/kvrocks/
COPY ./kvrocks.conf /kvrocks/

EXPOSE 6666:6666

USER root

#ENTRYPOINT ["kvrocks", "-c", "/var/lib/kvrocks/kvrocks.conf", "--dir", "/var/lib/kvrocks", "--pidfile", "/var/run/kvrocks/kvrocks.pid", "--bind", "0.0.0.0"]
ENTRYPOINT ["kvrocks", "-c", "/kvrocks/kvrocks.conf", "--dir", "/var/lib/kvrocks", "--pidfile", "/var/run/kvrocks/kvrocks.pid", "--bind", "0.0.0.0"]
