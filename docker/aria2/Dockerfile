ARG ARCH=docker.io
FROM ${ARCH}/alpine:3.8

LABEL maintainer="paulhybryant@gmail.com"

ENV TZ 'Asia/Chongqing'

COPY qemu-aarch64-static /usr/bin

RUN \
    apk -U upgrade \
    && apk add --no-cache bash aria2

VOLUME ["/config"]
VOLUME ["/downloads"]

EXPOSE 8800

CMD ["/usr/bin/aria2c", "--conf-path", "/config/aria2.conf"]
