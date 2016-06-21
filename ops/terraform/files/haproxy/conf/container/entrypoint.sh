#!/bin/bash
set -e
consul-template -consul=consul-server:8500 -config=/etc/consul-template/config.conf > /dev/stdout
