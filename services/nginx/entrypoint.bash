#!/usr/bin/env bash

set -e

term_handler() {
  echo "[entrypoint] received SIGTERM - stopping!"
  nginx -s quit
  exit 143; # 128 + 15 -- SIGTERM
}

main() {
  echo "[entrypoint] starting..."
  consul-template -consul=consul-server:8500 -config=/etc/consul-template/config.conf > /dev/stdout &
  nginx -c /etc/nginx/nginx.conf -g "daemon off;" & wait
}

trap term_handler SIGTERM
main
