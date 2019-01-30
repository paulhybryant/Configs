ARG ARCH=docker.io
FROM ${ARCH}/ubuntu:18.04
LABEL maintainer="paulhybryant@gmail.com"
ENV TZ 'Asia/Chongqing'
ENV TERM 'xterm-256color'
COPY qemu-aarch64-static /usr/bin/
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
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
  python-pyqt5.qtwebkit \
  python-pyqt5.qtsvg \
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
  python-apsw \
  python-sphinx \
  bash-completion \
  sudo \
  && useradd -m -s /bin/bash calibre \
  && echo 'calibre ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER calibre
RUN git clone --progress https://github.com/kovidgoyal/dukpy.git /tmp/dukpy \
  && cd /tmp/dukpy \
  && sudo ./setup.py install
RUN git clone --progress https://github.com/ebook-utils/css-parser.git /tmp/css-parser \
  && cd /tmp/css-parser \
  && sudo ./setup.py install
RUN git clone --progress https://github.com/kovidgoyal/calibre.git /tmp/calibre \
  && cd /tmp/calibre \
  && python setup.py bootstrap
# RUN sudo python setup.py install
CMD ["/bin/bash"]
