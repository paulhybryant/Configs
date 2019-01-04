FROM node:11-alpine

MAINTAINER paulhybryant <paulhybryant@gmail.com>

ENV TZ 'Asia/Chongqing'

COPY src /naotu

EXPOSE 8808

WORKDIR /naotu
CMD ["node", "server.js"]
