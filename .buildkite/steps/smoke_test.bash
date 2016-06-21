#!/usr/bin/env bash

set -euo pipefail
IFS=' '

source "$(dirname $0)/lib/path.bash"
source "$(dirname $0)/lib/utils.bash"
readonly TEMP_DIR=$(mktemp -d)

export GITREF="$(git rev-parse HEAD)"
export STACK="smoke"
export HAPROXY_CONTAINER_NAME="$(container_name smoke_test haproxy)"
export CONSUL_SERVER_CONTAINER_NAME="$(container_name smoke_test consul-server)"\

clean() {
  echo "~~~ cleaning stuff up"
  rm -rf "log/${STACK}*.log"
  docker rm -fv tester || true
  stack_containers | xargs docker kill || true
  stack_containers | xargs docker rm -fv || true
}

start_consul_server() {
  local consul_data_dir
  consul_data_dir="$TEMP_DIR/consul-data"
  mkdir -p "$consul_data_dir"

  labelise "start consul server" docker run \
    --detach \
    --expose 8500 \
    --name "$(container_name smoke_test consul-server)" \
    --label "com.pipelite.ref=$GITREF" \
    --label "com.pipelite.stack=$STACK" \
    --volume "/var/run/docker.sock:/tmp/docker.sock" \
    --volume "$consul_data_dir:/data" \
    --volume "$(pwd)/ops/terraform/files/consul-server/conf/config.json:/etc/consul/config.json" \
    gliderlabs/consul-server:0.5 -config-file=/etc/consul/config.json
  labelise "await consul server" docker run \
    --rm \
    -e PORTS=8500 \
    --link "$(container_name smoke_test consul-server):consul-server" \
    n3llyb0y/wait
}

start_registrator() {
  labelise "start registrator" docker run \
    --detach \
    --name "$(container_name smoke_test registrator)" \
    --label "com.pipelite.ref=$GITREF" \
    --label "com.pipelite.stack=$STACK" \
    --link "$(container_name smoke_test consul-server):consul-server" \
    --volume "/var/run/docker.sock:/tmp/docker.sock" \
    gliderlabs/registrator:v6 -internal consul://consul-server:8500
}

start_haproxy() {
  labelise "build haproxy" docker build --tag haproxy "$(pwd)/ops/terraform/files/haproxy/conf/container"
  labelise "start haproxy" docker run \
    --detach \
    --expose 80 \
    --expose 443 \
    --name "$(container_name smoke_test haproxy)" \
    --label "com.pipelite.ref=$GITREF" \
    --label "com.pipelite.stack=$STACK" \
    --link "$(container_name smoke_test consul-server):consul-server" \
    haproxy
}

build_stack() {
  labelise "build stack" docker-compose -f docker-compose.production.yml build
}

build_test_container() {
  # apt-get install httpie
  labelise "build test container" docker build --tag tester - <<Dockerfile
FROM gliderlabs/alpine:3.3
RUN apk --no-cache add --update python py-pip && pip install httpie
Dockerfile
}

setup() {
  echo "~~~ building and starting all the things"
  build_test_container &
  build_stack &
  start_consul_server &
  start_registrator &
  start_haproxy &

  wait

  echo '~~~ preparing database'
  docker-compose -f docker-compose.production.yml run -d --name "$(container_name smoke_test api_migrate)" api
  docker run --rm -e PORTS=5432 --link "pipelite_postgres_1:postgres" n3llyb0y/wait
  docker exec "$(container_name smoke_test api_migrate)" bash -c 'mix do ecto.create, ecto.migrate'
  docker kill "$(container_name smoke_test api_migrate)"

  docker-compose -f docker-compose.production.yml up 2> "log/${STACK}_error.log" > "log/${STACK}.log" &
}

teardown() {
  echo "~~~ teardown"
  clean
  unset GITREF
  unset STACK
  unset HAPROXY_CONTAINER_NAME
  unset CONSUL_SERVER_CONTAINER_NAME
}

stack_containers() {
  docker ps -aq --filter="label=com.pipelite.ref=$GITREF" --filter="label=com.pipelite.stack=$STACK"
}

test_http() {
  docker run --rm --link "$(container_name smoke_test haproxy)":haproxy tester http --timeout 1 --verify no --pretty all --follow --check-status  $@
  echo ""
}

wait_for_stack_to_boot() {
  local health_check
  local haproxy_container_name="$(container_name smoke_test haproxy)"
  local iteration="${1:-1}"
  local max_iterations="60"

  echo ""

  set +e
  health_check=$(docker run --rm --link $haproxy_container_name:haproxy tester http --timeout 1 --verify no --pretty all --headers --follow --check-status GET https://haproxy/health 2>&1)
  local status="$?"
  set -e
  if [[ $status -ne 0 ]]; then
    echo $(tput cuu 2)
    printf "Waiting for stack to start up ($iteration/$max_iterations) "
    for ((i=1; i <= $iteration; i++)); do echo -ne "."; done; echo -ne "\r"

    if [[ $iteration -eq $max_iterations ]]; then
      echo ""
      printf "$health_check"
      echo "Timed out..." && exit 1
    else
      wait_for_stack_to_boot $[$iteration+1]
    fi
  else
    echo ""
    printf "$health_check"
  fi
}

main() {
  clean
  setup

  echo "~~~ wait for stack to boot..."
  wait_for_stack_to_boot

  echo "+++ checking health"
  test_http GET https://haproxy/health
  echo ""

  echo "+++ checking API"
  test_http GET https://haproxy/api/v1/activities
  test_http GET https://haproxy/api/v1/builds
  test_http GET https://haproxy/api/v1/logs
  test_http GET https://haproxy/api/v1/projects
  echo ""

  echo "+++ checking UI"
  test_http GET https://haproxy/
  test_http GET https://haproxy/projects
  test_http GET https://haproxy/issues
}

trap teardown EXIT
main
