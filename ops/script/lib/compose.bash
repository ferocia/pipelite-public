#!/usr/bin/env bash

readonly COMPOSE=$(which docker-compose)

compose() {
  declare project_name="pipelite$1"; shift

  sudo -E "$COMPOSE" --file docker-compose.production.yml --project-name "${project_name}" "$@"
}
