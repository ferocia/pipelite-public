#!/usr/bin/env bash

readonly DEFAULT_STACK='blue'

current_stack() {
  local stack=$(consul-get "current_stack")

  if [[ $stack == "" ]]; then
    log_warn "current stack not set in consul k/v — assuming this is a first deploy"
    echo "$DEFAULT_STACK"
  else
    echo "$stack"
  fi
}

next_stack() {
  local current_stack="$1"

  if [[ $current_stack == 'blue' ]]; then
    echo 'green'
  else
    echo 'blue'
  fi
}
