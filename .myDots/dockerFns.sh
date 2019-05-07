#!/usr/bin/env bash

dComposeRunIt() {
  docker-compose run "$@"
}

dComposeUpD() {
  docker-compose up -d
}

dComposeDown() {
  docker-compose down --remove-orphans
}

dComposeBuild() {
  docker-compose build --no-cache "$1"
}

dRunIt() {
  docker run --rm -it "$@"
}

dRunBash() {
  docker run --rm -it --entrypoint /bin/bash "$1"
}

dBuildTagHere() {
  docker build . -t "$1"
}

dPS() {
  docker ps -a
}

dImages() {
  docker images ls
}

dImagesRm() {
  docker rmi "$@"
}

dImagesRmForce() {
  docker rmi --force "$@"
}

dContainers() {
  docker containers ls
}

dContainerRm() {
  docker container rm "$@"
}

dContainerReliesOn() {
  for container in "$@"; do
    local state
    state=$(docker inspect --format "{{.State.Running}}" "$container" 2>/dev/null)

    if [[ "$state" == "false" ]] || [[ "$state" == "" ]]; then
      echo "$container is not running, starting it for you."
      $container
    fi
  done
}

dCleanup() {
  local containers
  mapfile -t containers < <(docker ps -aq 2>/dev/null)
  docker rm "${containers[@]}" 2>/dev/null
  local volumes
  mapfile -t volumes < <(docker ps --filter status=exited -q 2>/dev/null)
  docker rm -v "${volumes[@]}" 2>/dev/null
  local images
  mapfile -t images < <(docker images --filter dangling=true -q 2>/dev/null)
  docker rmi "${images[@]}" 2>/dev/null
}

dRemoveStopped() {
  local name=$1
  local state
  state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)
  if [[ "$state" == "false" ]]; then
    docker rm "$name"
  fi
}
