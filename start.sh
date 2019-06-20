#!/bin/bash
echo $PAGESPEED_INSIGHTS_KEY > /tmp/var

# install latest version of docker the lazy way
curl -sSL https://get.docker.com | sh

# make it so you don't need to sudo to run docker commands
usermod -aG docker ubuntu

# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# copy the dockerfile into /srv/docker 
# if you change this, change the systemd service file to match
# WorkingDirectory=[whatever you have below]
mkdir /srv/docker
curl -o /srv/docker/docker-compose.yml https://raw.githubusercontent.com/ejoc/garie/master/docker-compose.yml

# copy in systemd unit file and register it so our compose file runs 
# on system restart
curl -o /etc/systemd/system/docker-compose-app.service https://raw.githubusercontent.com/ejoc/garie/master/docker-compose-app.service
systemctl enable docker-compose-app

# start up the application via docker-compose
# Required for garie-browsertime (needs to know where to map reports back too as its docker in docker...)
REPORT_DIR=$(pwd)/plugins/garie-browsertime DOCKER_PATH=$(which docker) CURRENT_UID=$(id -u):$(id -g) PAGESPEED_INSIGHTS_KEY=$PAGESPEED_INSIGHTS_KEY docker-compose -f /srv/docker/docker-compose.yml up -d
