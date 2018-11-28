FROM ubuntu:18.04

MAINTAINER paulhybryant <paulhybryant@gmail.com>

ENV TZ 'Asia/Beijing'

RUN apt update -y && apt upgrade -y \
    && apt install -y sudo curl iputils-ping build-essential file git stow \
    && useradd -m paulhybryant \
    && adduser paulhybryant sudo \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" < /dev/null
