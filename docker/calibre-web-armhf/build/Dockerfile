FROM armhf/ubuntu:12.04
LABEL maintainer="paulhybryant@gmail.com"

COPY qemu-arm-static /usr/bin/

RUN apt-get update -y \
  && apt-get install -y vim build-essential libxml2-dev libxslt1-dev devscripts \
  && mk-build-deps python2.7 --install \
  && apt-get install -y python2.7-build-deps

ADD Python-src-2.7.15.tgz /tmp/
WORKDIR /tmp/Python-2.7.15
RUN ./configure --prefix=/usr --enable-shared --with-threads --enable-ipv6 --with-system-ffi --with-system-expat --enable-unicode=ucs4 \
  && make && make install
COPY get-pip.py /tmp/
RUN python /tmp/get-pip.py

ADD calibre-3.37.0-i686.txz /opt/calibre/
ADD calibre-web.tar.gz /
WORKDIR /calibre-web
RUN pip install --no-cache-dir -U -r requirements.txt \
  && pip install --no-cache-dir -U -r optional-requirements.txt

EXPOSE 8083
VOLUME [/books /config]
CMD ["python", "cps.py"]
