#!/usr/bin/env bash

set -euo pipefail
IFS=' '

source "$(dirname $0)/lib/path.bash"
source "$(dirname $0)/lib/utils.bash"

main() {
  echo "+++ running credo"
  docker run --rm $(image_for_service api) credo list --strict
}

main
