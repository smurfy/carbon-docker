FROM alpine:3.13.5 as base

RUN true \
 && apk add --no-cache \
      findutils \
      py3-pyldap \
      runit \
      expect

FROM base as build

RUN true \
 && apk add --update \
      alpine-sdk \
      git \
      pkgconfig \
      py3-pip \
      py3-virtualenv==16.7.8-r0 \
      python3-dev \
      wget \
 && virtualenv /opt/graphite \
 && . /opt/graphite/bin/activate \
 && pip3 install simplejson

ARG version=1.1.8

# install whisper
ARG whisper_version=${version}
ARG whisper_repo=https://github.com/graphite-project/whisper.git
RUN git clone -b ${whisper_version} --depth 1 ${whisper_repo} /usr/local/src/whisper \
 && cd /usr/local/src/whisper \
 && . /opt/graphite/bin/activate \
 && python3 ./setup.py install

# install carbon
ARG carbon_version=${version}
ARG carbon_repo=https://github.com/graphite-project/carbon.git
RUN . /opt/graphite/bin/activate \
 && git clone -b ${carbon_version} --depth 1 ${carbon_repo} /usr/local/src/carbon \
 && cd /usr/local/src/carbon \
 && pip3 install -r requirements.txt \
 && python3 ./setup.py install

FROM base as production

COPY --from=build /opt /opt

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
