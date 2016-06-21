#!/usr/bin/env bash

set -euo pipefail
IFS=' '

readonly registry=${REGISTRY:-""}
readonly image_version=$(git rev-parse HEAD)

image_registry_tag() {
  local name="$1"

  echo "$registry/$name"
}

image_version_tag() {
  local name="$1"

  echo "$name:$image_version"
}

image_for_service() {
  local name="$1"

  if [[ -n $registry ]]; then
    echo $(image_registry_tag $(image_version_tag $name))
  else
    echo $(image_version_tag $name)
  fi
}

container_name() {
  local step_name="$1"
  local service="$2"

  echo "$step_name.$service.$image_version"
}

registry_retag_and_push() {
  local image versioned_tag versioned_registry_tag
  image="$1"
  versioned_tag=$(image_version_tag $image)
  versioned_registry_tag="$(image_registry_tag $versioned_tag)"

  docker tag --force $versioned_tag $versioned_registry_tag
  labelise "$image:push" docker push "$versioned_registry_tag" &
}
