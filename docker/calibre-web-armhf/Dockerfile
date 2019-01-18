FROM armhf/ubuntu:12.04
LABEL maintainer="paulhybryant@gmail.com"
COPY qemu-arm-static /usr/bin/
ADD calibre-3.37.0-i686.txz /opt/calibre/
ADD Python-2.7.15-tgz /tmp/Python-2.7.15
ADD calibre-web.tar.gz /app/
COPY get-pip.py /tmp/
RUN apt-get update -y \
  && apt-get install -y vim python build-essential
  && apt-get build-dep -y python2.7
WORKDIR /tmp/Python-2.7.15
RUN ./configure --prefix=/usr --enable-shared --with-threads --enable-ipv6 --with-system-ffi --with-system-expat --enable-unicode=ucs4 \
  && make && make install
RUN python /tmp/get-pip.py
WORKDIR /app/calibre-web
RUN pip install --no-cache-dir -U -r requirements.txt \
  && pip install --no-cache-dir -U -r optional-requirements.txt
ENTRYPOINT ["/init"]
EXPOSE 8083
VOLUME [/books /config]
CMD ["/bin/bash"]
