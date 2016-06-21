#!/bin/bash -eu

# Install Docker daemon
sudo curl -sSL https://get.docker.com/ | sh

# Copy in config files
sudo mv /tmp/conf/docker.defaults /etc/default/docker
sudo chown root: /etc/default/docker
sudo mv /tmp/conf/docker.service /lib/systemd/system/docker.service
sudo chown root: /lib/systemd/system/docker.service

# Restart the docker service
sudo systemctl daemon-reload
sudo systemctl enable docker

# Install docker-compose
sudo curl -o /usr/local/bin/docker-compose -L https://github.com/docker/compose/releases/download/1.5.1/docker-compose-Linux-x86_64
sudo chmod +x /usr/local/bin/docker-compose

# Install docker-gc
sudo curl -o /etc/cron.hourly/docker-gc -L https://raw.githubusercontent.com/spotify/docker-gc/master/docker-gc
sudo chmod +x /etc/cron.hourly/docker-gc

# Setup docker logging
sudo mv /tmp/conf/docker.rsyslog /etc/rsyslog.d/10-docker.conf
sudo mv /tmp/conf/docker.logrotate /etc/logrotate.d/docker
sudo systemctl restart rsyslog
