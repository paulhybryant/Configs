FROM armhf/ubuntu:12.04
LABEL maintainer="paulhybryant@gmail.com"

COPY qemu-arm-static /usr/bin/
COPY python_2.7.15-1_armhf.deb /tmp
COPY get-pip.py /tmp/
ADD calibre-3.37.0-i686.txz /opt/calibre/
ADD calibre-web.tar.gz /

WORKDIR /calibre-web
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends build-essential libxml2-dev libxslt1-dev libz-dev libsqlite3-0 \
  && rm -rf /var/lib/apt/lists/* \
  && dpkg -i --force-all /tmp/python_2.7.15-1_armhf.deb \
  && python /tmp/get-pip.py \
  && pip install -U setuptools wheel \
  && pip install -U -r requirements.txt \
  && pip install -U -r optional-requirements.txt

EXPOSE 8083
VOLUME [/books /config]
CMD ["python", "cps.py"]
