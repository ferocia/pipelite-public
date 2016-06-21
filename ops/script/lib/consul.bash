#!/usr/bin/env bash

readonly CONSUL_URL="localhost:8500"

consul-cmd() {
  declare path="$1"; shift
  local cmd="curl"
  $cmd --fail -Ss "${CONSUL_URL:?}$path" "$@"
}

consul-info() {
  declare desc="Show all metadata for key"
  declare key="${1/#\//}"
  consul-cmd "/v1/kv/$key" \
    | jq -r .[]
}

consul-get() {
  declare desc="Get the value of key"
  declare key="${1/#\//}"
  consul-encoded "$key" \
    | base64 -d \
    | echo "$(cat)"
}

consul-encoded() {
  declare desc="Get the base64 encoded value of key"
  declare key="${1/#\//}"
  consul-cmd "/v1/kv/$key" \
    | jq -r .[].Value
}

consul-set() {
  declare desc="Set the value of key"
  declare key="${1/#\//}" value="$2"
  consul-cmd "/v1/kv/$key" -X PUT -d "$value" > /dev/null
}

consul-del() {
  declare desc="Delete key"
  declare key="${1/#\//}"
  consul-cmd "/v1/kv/$key" -X DELETE > /dev/null
}

consul-ls() {
  declare desc="List keys under key"
  declare key="${1/#\//}"
  if [[ ! "$key" ]]; then
    consul-cmd "/v1/kv/?keys&separator=/" \
      | jq -r .[] \
      | sed 's|/$||'
  else
    consul-cmd "/v1/kv/$key/?keys&separator=/" \
      | jq -r .[] \
      | sed "s|$key/||" \
      | grep -v ^$ \
      | sed 's|/$||'
  fi
}

consul-service() {
  declare service="$1"
  consul-cmd "/v1/health/service/$service"
}
