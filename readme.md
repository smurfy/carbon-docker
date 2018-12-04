Alpine based carbon container
=============================

This container provides a small variant of only carbon-cache.

Currently tags support needs a bit of manual configuration

How to use:
-----------

    docker run -p 2003:2003 -p 2004:2004 -p 7002:7002 -v graphite-data:/data/graphite smurfynet/carbon

Exposed ports can vary depending of usage of protocols and linking