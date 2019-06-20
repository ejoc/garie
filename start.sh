#!/bin/bash
echo $PAGESPEED_INSIGHTS_KEY > /tmp/var

# start up the application via docker-compose
# Required for garie-browsertime (needs to know where to map reports back too as its docker in docker...)
REPORT_DIR=$(pwd)/plugins/garie-browsertime DOCKER_PATH=$(which docker) CURRENT_UID=$(id -u):$(id -g) PAGESPEED_INSIGHTS_KEY=$PAGESPEED_INSIGHTS_KEY docker-compose -f /srv/docker/docker-compose.yml up -d
