FROM  ubuntu:18.04
MAINTAINER  paulhybryant <paulhybryant@gmail.com>
ENV  TZ  'Asia/Chongqing'
RUN  ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
  && echo ${TZ} > /etc/timezone \
  && apt-get update -y \
  && apt-get install -y \
  apt-utils \
  git \
  vim \
  python \
  pkg-config \
  build-essential \
  qt5-qmake \
  qt5-default \
  python-pyqt5 \
  pyqt5-dev \
  libglib2.0-dev \
  libfontconfig1-dev \
  python-dev \
  libssl-dev \
  libicu-dev \
  libsqlite3-dev \
  libchm-dev \
  libpodofo-dev \
  python-sip-dev \
  qtbase5-private-dev \
  libusb-1.0-0-dev \
  libmtp-dev \
  python-lxml \
  python-msgpack \
  gettext \
  python-setuptools \
  python-html5-parser \
  python-mechanize \
  python-pil \
  python-cssutils \
  python-regex \
  python-dateutil \
  sudo \
  && useradd -m -s /bin/bash calibre \
  && echo 'calibre ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER calibre
RUN git clone https://github.com/kovidgoyal/dukpy.git /tmp/dukpy \
  && cd /tmp/dukpy \
  && sudo ./setup.py install \
  && git clone https://github.com/kovidgoyal/calibre.git /tmp/calibre \
  && cd /tmp/calibre \
  && python setup.py bootstrap \
  && git clone https://github.com/kovidgoyal/build-calibre.git /tmp/build-calibre
# RUN cd /tmp/build-calibre \
  # && ./linux 64
