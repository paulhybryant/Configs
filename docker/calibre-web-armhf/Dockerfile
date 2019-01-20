FROM armhf/ubuntu:12.04
LABEL maintainer="paulhybryant@gmail.com"

COPY qemu-arm-static /usr/bin/
RUN apt-get update -y \
  && apt-get install -y libxml2-dev libxslt1-dev libz-dev

COPY python_2.7.15-1_armhf.deb /tmp
RUN dpkg -i --force-all /tmp/python_2.7.15-1_armhf.deb
COPY get-pip.py /tmp/
RUN python /tmp/get-pip.py

ADD calibre-3.37.0-i686.txz /opt/calibre/
ADD calibre-web.tar.gz /
WORKDIR /calibre-web
RUN pip install setuptools wheel \
  && pip install --target vendor -r requirements.txt \
  && pip install --target vendor -r optional-requirements.txt

EXPOSE 8083
VOLUME [/books /config]
CMD ["python", "cps.py"]
