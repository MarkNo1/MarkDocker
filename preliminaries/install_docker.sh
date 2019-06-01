#! /bin/bash

# Root check
if [ $(id -u) != "0" ]; then
    echo -e "Docker needs root-privileges. (https://unix.stackexchange.com/questions/156938/why-does-docker-need-root-privileges)"
    sudo "$0" "$@"  # Modified as suggested below.
    exit $?
fi



####### DOCKER

# Select clean install
while true; do
    read -p "Perform clean installation? [y,n]: " CHOSE
    CHOSE=${CHOSE^^}
    if [ "$CHOSE" == "" ]; then
        PROCEDURE="0"
        break;
    elif [ "$CHOSE" == "N" ]; then
        PROCEDURE="0"
        echo -e "[No Clean Installation]"
        break;
    elif [ "$CHOSE" == "Y" ]; then
        PROCEDURE="1"
        echo -e "[Clean Installation]"
        break;
    fi
done

## NoMACINE flag
read -p "Install NoMachine? [y,n]: " NOMACHINE_FLAG
if [ "$NOMACHINE_FLAG" == "y" ]; then
    INSTALL_NX=1
else
    INSTALL_NX=0
fi

TRUE=1

# Nvidia check
GPU=$(lspci | grep -i --color 'vga\|3d\|2d')
if [[ $GPU == *"NVIDIA"* ]]; then
  echo "NVIDIA AVAILABLE!"
  echo -e $GPU
  GPU_AVAILABLE=1
fi

# Uninstall previous versions - PROCEDURE CLEAN Install
if [ "$PROCEDURE" -eq "$TRUE" ];then
  echo "Clean install docker";
  sudo apt-get remove docker docker-engine docker.io containerd runc
fi

sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install Docker
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# Check Hello World
sudo docker run hello-world



###### NVIDIA DOCKER
if [ "$GPU_AVAILABLE" -eq "$TRUE" ]; then

  # CLEAN PROCEDURE
  if [ "$PROCEDURE" -eq "$TRUE" ];then
    # If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
    docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
    sudo apt-get purge -y nvidia-docker
  fi

  # Add the package repositories
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
    sudo apt-key add -
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-docker.list
  sudo apt-get update

  # Install nvidia-docker2 and reload the Docker daemon configuration
  sudo apt-get install -y nvidia-docker2
  sudo pkill -SIGHUP dockerd

fi

if [ "$INSTALL_NX" -eq "$TRUE" ]; then
  echo -e "Installing NoMachine!"
fi
