#!/usr/bin/env bash

set -euo pipefail
IFS=' '

source "$(dirname $0)/lib/path.bash"
source "$(dirname $0)/lib/utils.bash"

main() {
  echo "+++ running unit tests"
  docker run --rm $(image_for_service ui) test
}

main
