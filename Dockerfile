FROM alpine:3.8

ENV WHISPER_VERSION 1.1.5
ENV CARBON_VERSION 1.1.5

RUN apk add --no-cache python2 && \
    apk add --no-cache --virtual .build-deps musl-dev build-base python2-dev py2-pip && \
    pip install twisted simplejson && \
    pip install whisper==$WHISPER_VERSION && \
    pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/lib" carbon==$CARBON_VERSION && \
    apk del .build-deps && \
    rm -rf /root/.cache/pip

ADD run.sh /run.sh

RUN mkdir -p /data/graphite/conf && \
    mkdir -p /data/graphite/storage/whisper && \
    touch /data/graphite/storage/graphite.db /data/graphite/storage/index && \
    chmod 0775 /data/graphite/storage /data/graphite/storage/whisper && \
    chmod 0664 /data/graphite/storage/graphite.db && \
    chmod +x /run.sh

# Carbon line receiver port
EXPOSE 2003
# Carbon UDP receiver port
EXPOSE 2003/udp
# Carbon pickle receiver port
EXPOSE 2004
# Carbon cache query port
EXPOSE 7002

VOLUME ["/data/graphite"]

ENV GRAPHITE_STORAGE_DIR /data/graphite/storage
ENV GRAPHITE_CONF_DIR /data/graphite/conf

STOPSIGNAL SIGTERM

CMD ["/run.sh"]
