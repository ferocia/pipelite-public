#!/usr/bin/env bash

set -euo pipefail
IFS=' '

setup() {
  echo "~~~ setup"
  eval `ssh-agent -s`
  chmod 0600 ops/conf/pipelite.pem
  ssh-add ./ops/conf/pipelite.pem
  git remote add production ubuntu@pipelite.ferocia.com.au:/var/git/pipelite.git || true
}

main() {
  setup

  echo "+++ deploying to production"
  git push -f production "$BUILDKITE_COMMIT":master
}

main
