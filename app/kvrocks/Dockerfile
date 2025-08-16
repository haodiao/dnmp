ARG KVROCKS_VERSION
ARG TZ

FROM debian:bookworm-slim AS build

ARG MORE_BUILD_ARGS
ARG CONTAINER_PACKAGE_URL

RUN if [ "${CONTAINER_PACKAGE_URL}" != "" ] ; then sed -i "s/deb.debian.org/${CONTAINER_PACKAGE_URL}/g" /etc/apt/sources.list.d/debian.sources ; fi
RUN if [ "${CONTAINER_PACKAGE_URL}" != "" ] ; then sed -i "s/security.debian.org/${CONTAINER_PACKAGE_URL}/g" /etc/apt/sources.list.d/debian.sources ; fi

RUN DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get upgrade -y && apt-get -y --no-install-recommends install ca-certificates git build-essential autoconf cmake libtool python3 libssl-dev clang && apt-get autoremove && apt-get clean

WORKDIR /kvrocks

RUN git clone --depth 1 https://github.com/apache/kvrocks.git /kvrocks
RUN ./x.py build --compiler=clang -DENABLE_OPENSSL=ON -DPORTABLE=1 -DCMAKE_BUILD_TYPE=Release -j $(nproc) $MORE_BUILD_ARGS

FROM debian:bookworm-slim

ARG CONTAINER_PACKAGE_URL

RUN if [ "${CONTAINER_PACKAGE_URL}" != "" ] ; then sed -i "s/deb.debian.org/${CONTAINER_PACKAGE_URL}/g" /etc/apt/sources.list.d/debian.sources ; fi
RUN if [ "${CONTAINER_PACKAGE_URL}" != "" ] ; then sed -i "s/security.debian.org/${CONTAINER_PACKAGE_URL}/g" /etc/apt/sources.list.d/debian.sources ; fi

RUN DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get upgrade -y && apt-get -y install openssl ca-certificates redis-tools

RUN mkdir /var/run/kvrocks

VOLUME /var/lib/kvrocks

COPY --from=build /kvrocks/build/kvrocks /bin/

HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
    CMD redis-cli -p 6666 PING | grep -E '(PONG|NOAUTH)' || exit 1

#COPY ./LICENSE ./NOTICE ./licenses /kvrocks/
#COPY ./kvrocks.conf /var/lib/kvrocks/
COPY ./kvrocks.conf /kvrocks/

ENV MALLOC_CONF="prof:true,prof_active:false,background_thread:true"

EXPOSE 6666:6666

USER root

#ENTRYPOINT ["kvrocks", "-c", "/var/lib/kvrocks/kvrocks.conf", "--dir", "/var/lib/kvrocks", "--pidfile", "/var/run/kvrocks/kvrocks.pid", "--bind", "0.0.0.0"]
ENTRYPOINT ["kvrocks", "-c", "/kvrocks/kvrocks.conf", "--dir", "/var/lib/kvrocks", "--pidfile", "/var/run/kvrocks/kvrocks.pid", "--bind", "0.0.0.0"]
