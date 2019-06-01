#! /bin/bash

# Load lib
source lib.sh

# Root check
RootCheck

sudo docker volume create portainer_data
sudo docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
