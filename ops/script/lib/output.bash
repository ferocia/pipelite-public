#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/colour.bash"
color-init

timestamp() {
  date +"%Y/%m/%d - %H:%M:%S.%3N"
}

puts() {
  echo -e "$@"
}

print() {
  printf "$@"
}

log_success() {
  echo "==> $(timestamp) | INFO | $@" | >&2 green
}

log_info() {
  echo "==> $(timestamp) | INFO | $@" | >&2 blue
}

log_warn() {
  echo "==> $(timestamp) | WARN | $@" | >&2 yellow
}

log_error() {
  echo "==> $(timestamp) | FAIL | $@" | >&2 red
}

log() {
  echo "$@"
}

indent() {
  while read data; do
    echo "    ${data}"
  done;
}

ok_status() {
  puts " [$(green OK)]"
}

fail_status() {
  puts " [$(red FAIL)]"
}
