#!/bin/bash

# Root check
RootCheck () {
  if [ $(id -u) != "0" ]; then
      echo -e "Docker needs root-privileges"
      echo -e "https://unix.stackexchange.com/questions/156938/why-does-docker-need-root-privileges"
      sudo "$0" "$@"
      exit $?
  fi
}

# GPU Check
CheckNvidiaGpu () {
  # Nvidia check
  GPU=$(lspci | grep -i --color 'vga\|3d\|2d')
  if [[ $GPU == *"NVIDIA"* ]]; then
    echo -e "CheckNvidiaGpu: $GPU"
    return true
  else
    return false
  fi
}

# Get Type docker to build
GetDockerType () {
  if ["$(CheckNvidiaGpu)" = true]; then
    TYPE=gpu
  else
    TYPE=cpu
  fi
}


# Get Docker Image
GetPathDockerImage() {
  #1 Type
  #2 Model
  return "../images/${1}/${2}/Dockerfile"
}

# Build Docker image
DockerBuild () {
  docker build  -f  ${1} . --tag ${2}
}
