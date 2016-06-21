#!/usr/bin/env bash

set -euo pipefail
IFS=' '

source "$(dirname $0)/lib/path.bash"
source "$(dirname $0)/lib/utils.bash"

readonly node_env=${NODE_ENV:-test}
readonly mix_env=${MIX_ENV:-test}

build_ui() {
  labelise "ui:build" docker build --tag "$(image_version_tag ui)" --build-arg IMAGE_ID=$image_version --build-arg NODE_ENV=$node_env services/ui &
}

build_api() {
  labelise "api:build" docker build --tag "$(image_version_tag api)" --build-arg IMAGE_ID=$image_version --build-arg MIX_ENV=$mix_env services/api &
}

build_nginx() {
  labelise "nginx:build" docker build --tag "$(image_version_tag nginx)" --build-arg IMAGE_ID=$image_version services/nginx &
}

build_postgres() {
  labelise "postgres:build" docker build --tag "$(image_version_tag postgres)" --build-arg IMAGE_ID=$image_version services/postgres &
}

main() {
  echo '--- docker info'
  docker info
  docker version
  echo '--- building images'
  build_ui
  build_api
  build_nginx
  build_postgres
  wait

  # skip push if registry is not defined
  if [[ -n $registry ]]; then
    echo '--- retagging and pushing images'
    registry_retag_and_push "ui"
    registry_retag_and_push "api"
    registry_retag_and_push "nginx"
    registry_retag_and_push "postgres"
    wait
  fi
}

main
