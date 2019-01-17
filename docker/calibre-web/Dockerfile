FROM armhf/ubuntu:12.04
LABEL maintainer="paulhybryant@gmail.com"
ADD calibre-3.37.0-i686.txz /opt/calibre/
RUN apt-get update -y \
  && apt-get install -y vim git python curl
ADD calibre-web.tar.gz /app/
RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py \
  && python /tmp/get-pip.py
WORKDIR /app/calibre-web
RUN pip install --no-cache-dir -U -r requirements.txt \
  && pip install --no-cache-dir -U -r optional-requirements.txt
# ENTRYPOINT ["/init"]
EXPOSE 8083
VOLUME [/books /config]
CMD ["/bin/bash"]
