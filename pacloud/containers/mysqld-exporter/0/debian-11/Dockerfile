FROM docker.io/pacloud/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://pacloud.com/contact" \
      org.opencontainers.image.description="Application packaged by Pacloud" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="0.14.0-debian-11-r89" \
      org.opencontainers.image.source="https://github.com/pacloud/containers/tree/main/pacloud/mysqld-exporter" \
      org.opencontainers.image.title="mysqld-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.14.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps
RUN mkdir -p /tmp/pacloud/pkg/cache/ && cd /tmp/pacloud/pkg/cache/ && \
    COMPONENTS=( \
      "mysqld-exporter-0.14.0-157-linux-${OS_ARCH}-debian-11" \
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
RUN ln -sf /opt/pacloud/mysqld-exporter/bin/mysqld_exporter /bin/mysqld_exporter

ENV APP_VERSION="0.14.0" \
    PACLOUD_APP_NAME="mysqld-exporter" \
    PATH="/opt/pacloud/mysqld-exporter/bin:$PATH"

EXPOSE 9104

WORKDIR /opt/pacloud/mysqld-exporter
USER 1001
ENTRYPOINT [ "mysqld_exporter" ]
