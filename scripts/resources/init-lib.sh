#! /bin/bash

# Check status service
CheckService () {
  STATUS=$(sudo service $1 status)
  if [[ $STATUS != *"is running"* ]]; then
    return 0
  else
    return 1
fi
}

StartService () {
  echo "${BLUE}starting $1 service${NORMAL}"
  sudo service $1 start
}

ControllService () {
  CHECK=$(CheckService $1)
  if [[ $CHECK == "0" ]]; then
    echo "${RED}$1 is not running!${NORMAL}"
    StartService $1
  else
    echo "${GREEN}[$1]${NORMAL}"
  fi
}


CheckRos2 () {
  if [ ! -f /opt/ros/crystal/setup.zsh  ]; then
    return 0
  else
    return 1
fi
}

ToolsLibsNeeded () {
  sudo apt update && sudo apt install -y \
    build-essential \
    cmake \
    git \
    python3-colcon-common-extensions \
    python3-lark-parser \
    python3-pip \
    python-rosdep \
    python3-vcstool \
    wget
  # install some pip packages needed for testing
  python3 -m pip install -U \
    argcomplete \
    flake8 \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-docstrings \
    flake8-import-order \
    flake8-quotes \
    pytest-repeat \
    pytest-rerunfailures \
    pytest \
    pytest-cov \
    pytest-runner \
    setuptools
  # install Fast-RTPS dependencies
  sudo apt install --no-install-recommends -y \
    libasio-dev \
    libtinyxml2-dev
}

Ros2 () {
  sudo apt install ros-crystal-desktop -y
}


Rosedep () {
  sudo apt install -y python-rosdep
  rosdep init
  rosdep update
  sudo rosdep init
  rosdep update
  # [Ubuntu 18.04]
  rosdep install --from-paths src --ignore-src --rosdistro crystal -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 rti-connext-dds-5.3.1 urdfdom_headers"
  python3 -m pip install -U lark-parser
  # Auto Completition
  sudo apt install python3-argcomplete

}

Ros2GetBaseWs () {
  mkdir -p ~/ros2_ws/src
  cd ~/ros2_ws
  wget https://raw.githubusercontent.com/ros2/ros2/release-latest/ros2.repos
  vcs import src < ros2.repos
}

AdditionalDDs () {
  # PrismTech OpenSplice Debian Packages built by OSRF
  # For Crystal Clemmys
  sudo apt install ros-crystal-rmw-opensplice-cpp -y # for OpenSplice
  sudo apt install ros-crystal-rmw-connext-cpp -y # for RTI Connext (requires license agreement)

  # Many others .. will update this TO-DO
}

Ros2Build () {
  cd ~/ros2_ws
  # On Ubuntu Linux Bionic Beaver 18.04
  colcon build --symlink-install
}

ClangPower () {
  sudo apt install clang
  export CC=clang
  export CXX=clang++
}

InstallationRos2 () {
  if [[ $(CheckRos2) == "0" ]]; then

    ToolsLibsNeeded
    Ros2
    AdditionalDDs
    Ros2GetBaseWs
    Rosdep
    ClangPower
    Ros2Build

  fi
}
