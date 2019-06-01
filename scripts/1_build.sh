#! /bin/bash

#Include lib
source lib.sh

# Root check
RootCheck

# Parameters
VERSION=1.0
MODE=gui
ROS=crystal
LINUX=18
TYPE=$(GetDockerType)
IMAGE=${ROS}-${TYPE}-${LINUX}:${VERSION}

# Get Image
PATH=$(GetPathDockerImage $TYPE $VERSION)

# Build
DockerBuild $PATH $IMAGE
