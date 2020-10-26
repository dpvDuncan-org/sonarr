ARG BASE_IMAGE_PREFIX

FROM multiarch/qemu-user-static as qemu

FROM ${BASE_IMAGE_PREFIX}alpine

ARG sonarr_url
ARG SONARR_RELEASE

ENV PUID=0
ENV PGID=0
ENV SONARR_RELEASE=${SONARR_RELEASE}

COPY --from=qemu /usr/bin/qemu-*-static /usr/bin/
COPY scripts/start.sh /

RUN apk -U --no-cache upgrade

RUN apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
RUN apk add --no-cache libmediainfo icu-libs libintl sqlite-libs
RUN apk add --no-cache --virtual=.build-dependencies ca-certificates curl
RUN mkdir -p /opt/sonarr /config
RUN curl -o - -L "${sonarr_url}" | tar xz -C /opt/sonarr --strip-components=1
RUN apk del .build-dependencies
RUN chmod -R 777 /opt/sonarr /start.sh

RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /usr/bin/qemu-*-static

# ports and volumes
EXPOSE 8989
VOLUME /config

CMD ["/start.sh"]