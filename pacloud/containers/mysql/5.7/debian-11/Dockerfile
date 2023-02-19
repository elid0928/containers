FROM docker.io/pacloud/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://pacloud.com/contact" \
      org.opencontainers.image.description="Application packaged by Pacloud" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="5.7.41-debian-11-r7" \
      org.opencontainers.image.source="https://github.com/pacloud/containers/tree/main/pacloud/mysql" \
      org.opencontainers.image.title="mysql" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="5.7.41"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libaio1 libcom-err2 libcrypt1 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libsasl2-2 libssl1.1 libstdc++6 libtinfo6 libtirpc3 procps psmisc
RUN mkdir -p /tmp/pacloud/pkg/cache/ && cd /tmp/pacloud/pkg/cache/ && \
    COMPONENTS=( \
      "ini-file-1.4.5-0-linux-${OS_ARCH}-debian-11" \
      "mysql-5.7.41-0-linux-${OS_ARCH}-debian-11" \
      "gosu-1.16.0-1-linux-${OS_ARCH}-debian-11" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.pacloud.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.pacloud.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi && \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" && \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/pacloud --strip-components=2 --no-same-owner --wildcards '*/files' && \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/pacloud
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/pacloud/scripts/mysql/postunpack.sh
ENV APP_VERSION="5.7.41" \
    PACLOUD_APP_NAME="mysql" \
    PATH="/opt/pacloud/common/bin:/opt/pacloud/mysql/bin:/opt/pacloud/mysql/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/opt/pacloud/scripts/mysql/entrypoint.sh" ]
CMD [ "/opt/pacloud/scripts/mysql/run.sh" ]
