ARG ARCH=docker.io
FROM ${ARCH}/node:11-alpine

LABEL maintainer="paulhybryant@gmail.com"

ENV TZ 'Asia/Chongqing'

COPY src /naotu

EXPOSE 8808

WORKDIR /naotu
CMD ["node", "server.js"]
