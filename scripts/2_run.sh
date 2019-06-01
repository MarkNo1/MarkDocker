#! /bin/bash

source lib.sh

# Custom parameters
TYPE=gpu
VERSION=1.0
MODE=terminal
ROS=crystal
LINUX=18
# Not Custom parameters
IMAGE=${ROS}-${TYPE}-${LINUX}:${VERSION}
CONTAINER=${ROS}-${TYPE}-${MODE}-${VERSION}

# Root check
RootCheck

sudo docker run -d --restart=always -it --name $CONTAINER\
                --user=$(id -u):$(id -g) \
                -v /tmp/.X11-unix:/tmp/.X11-unix \
                -v /data:/data \
                -p2223:28 -e DISPLAY --ipc host --cap-add=SYS_PTRACE \
                --runtime=nvidia                \
                --privileged \
                -p 4282:4282 \
                $IMAGE /bin/zsh
