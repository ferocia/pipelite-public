#!/usr/bin/env bash

set -euo pipefail
IFS=' '

source "$(dirname $0)/lib/path.bash"
source "$(dirname $0)/lib/utils.bash"

setup() {
  echo "~~~ setup"
  docker run --name $(container_name api_test postgres) -d $(image_for_service postgres)
  docker run -e PORTS=5432 --link $(container_name api_test postgres):postgres n3llyb0y/wait
  docker run --rm --link $(container_name api_test postgres):postgres $(image_for_service api) do ecto.create, ecto.migrate
}

teardown() {
  echo "~~~ teardown"
  docker kill $(container_name api_test postgres)
  docker rm -vf $(container_name api_test postgres)
}

main() {
  setup

  echo "+++ running unit tests"
  docker run --rm --link $(container_name api_test postgres):postgres $(image_for_service api) test
}

trap teardown EXIT
main
