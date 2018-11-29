FROM ubuntu:18.04

MAINTAINER paulhybryant <paulhybryant@gmail.com>

ENV TZ 'Asia/Beijing'

RUN apt update -y && apt upgrade -y \
    && apt install -y sudo curl iputils-ping build-essential file git stow vim tmux zsh locales jq silversearcher-ag locate gawk \
    && locale-gen en_US.UTF-8 \
    && useradd -m paulhybryant \
    && su - paulhybryant -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" < /dev/null' \
    && adduser paulhybryant sudo
