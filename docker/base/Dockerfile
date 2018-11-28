FROM ubuntu:18.04

MAINTAINER paulhybryant <paulhybryant@gmail.com>

ENV TZ 'Asia/Beijing'

RUN apt update -y && apt upgrade -y \
    && useradd -m paulhybryant \
    && adduser paulhybryant sudo \
    && apt install -y curl iputils-ping \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" < /dev/null
