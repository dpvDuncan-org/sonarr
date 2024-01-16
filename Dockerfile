# syntax=docker/dockerfile:1

FROM alpine AS builder

ARG sonarr_url
ARG TARGETARCH

COPY scripts/start.sh /

RUN apk -U --no-cache upgrade

RUN apk add --no-cache libmediainfo icu-libs libintl sqlite-libs ca-certificates curl
RUN mkdir -p /opt/sonarr /config
RUN case "${TARGETARCH}" in \
        "arm") echo "arm" > /tmp/sonarr_arch;;\
        "arm64") echo "arm64" > /tmp/sonarr_arch;;\
        "amd64") echo "x64" > /tmp/sonarr_arch;;\
        *) echo "none" > /tmp/sonarr_arch;;\
    esac
RUN sonarr_arch=`cat /tmp/sonarr_arch`; curl -o - -L "${sonarr_url}&arch=${sonarr_arch}" | tar xz -C /opt/sonarr --strip-components=1
RUN apk del curl
RUN chmod -R 777 /opt/sonarr /start.sh

RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

FROM scratch

ARG SONARR_RELEASE

ENV PUID=0
ENV PGID=0
ENV SONARR_RELEASE=${SONARR_RELEASE}

COPY --from=builder / /
# ports and volumes
EXPOSE 8989
VOLUME /config

CMD ["/start.sh"]
