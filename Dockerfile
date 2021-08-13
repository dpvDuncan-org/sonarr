# syntax=docker/dockerfile:1
ARG BASE_IMAGE_PREFIX

FROM ${BASE_IMAGE_PREFIX}alpine

ARG sonarr_url
ARG SONARR_RELEASE

ENV PUID=0
ENV PGID=0
ENV SONARR_RELEASE=${SONARR_RELEASE}

COPY scripts/start.sh /

RUN apk -U --no-cache upgrade

RUN apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
RUN apk add --no-cache libmediainfo icu-libs libintl sqlite-libs ca-certificates curl
RUN mkdir -p /opt/sonarr /config
RUN curl -o - -L "${sonarr_url}" | tar xz -C /opt/sonarr --strip-components=1
RUN apk del curl
RUN chmod -R 777 /opt/sonarr /start.sh

RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# ports and volumes
EXPOSE 8989
VOLUME /config

CMD ["/start.sh"]