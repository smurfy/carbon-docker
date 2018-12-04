#!/bin/sh

test -e "/data/graphite/conf/storage-aggregation.conf" && echo "storage-aggregation.conf already exists!" || cp /var/lib/graphite/conf/storage-aggregation.conf.example /data/graphite/conf/storage-aggregation.conf
test -e "/data/graphite/conf/storage-schemas.conf" && echo "storage-schemas.conf already exists!" || cp /var/lib/graphite/conf/storage-schemas.conf.example /data/graphite/conf/storage-schemas.conf
test -e "/data/graphite/conf/carbon.conf" && echo "carbon.conf already exists!" || cp /var/lib/graphite/conf/carbon.conf.example /data/graphite/conf/carbon.conf

/var/lib/graphite/bin/carbon-cache.py start --debug