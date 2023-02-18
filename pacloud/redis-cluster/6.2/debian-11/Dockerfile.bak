FROM centos:7

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="6.2.10-centos" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/redis-cluster" \
      org.opencontainers.image.title="redis-cluster" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="6.2.10"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN yum update -y&& yum install -y ca-certificates curl libssl1.1 procps make gcc glibc-devel
# https://download.redis.io/releases/redis-6.2.10.tar.gz
# https://github.com/tianon/gosu/releases/download/1.16/gosu-amd64
RUN mkdir -p /tmp/pacloud/pkg/cache/ && cd /tmp/pacloud/pkg/cache/ && \
      curl -SsLf "https://download.redis.io/releases/redis-6.2.10.tar.gz" -O && \
      curl -SsLf "https://github.com/tianon/gosu/releases/download/1.16/gosu-amd64" -O && \
      tar -zxf "redis-6.2.10.tar.gz" && cd redis-6.2.10 && make && make install && \
      cd ../ && chmod +x gosu-amd64 && \
      mkdir -p files/common/bin/ && mv gosu-amd64 files/common/bin/gosu && \
      mkdir -p files/redis/{bin,etc,licenses} && mkdir -p /opt/bitnami && \
      mv redis-6.2.10/src/redis-benchmark redis-6.2.10/src/redis-cli redis-6.2.10/src/redis-server redis-6.2.10/src/redis-sentinel redis-6.2.10/src/redis-check* files/redis/bin/ && \
      mv redis-6.2.10/redis.conf files/redis/etc/redis-default.conf && \
      ls -al files/ && \
      mkdir -p /opt/bitnami/redis  && mv files/* /opt/bitnami/ 
COPY redis-default.conf /opt/bitnami/redis/etc/redis-default.conf
RUN yum update -y && yum upgrade -y && \
    yum clean all&& rm -rf /var/cache/yum
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/redis-cluster/postunpack.sh
ENV APP_VERSION="6.2.10" \
    BITNAMI_APP_NAME="redis-cluster" \
    PATH="/opt/bitnami/redis/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 6379

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/redis-cluster/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redis-cluster/run.sh" ]
