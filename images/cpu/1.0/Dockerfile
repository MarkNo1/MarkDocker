FROM ubuntu:18.04
LABEL maintainer "Markno1 - marco.treglia1@gmail.com"

## New User
RUN useradd -m -p $(openssl passwd -1 "mark") -s /bin/bash -G sudo mark

# Utils
RUN   apt-get update && apt-get install -y tree htop bmon nano terminator apt-transport-https clang-format-6.0 git  openssh-server && \
      rm -rf /var/lib/apt/lists/*

# Enable SSH at boot, and customize X session
RUN echo "X11UseLocalhost=no" >> /etc/ssh/sshd_config && \
    echo "Port 28" >> /etc/ssh/sshd_config


# Install zsh
ENV TOKEN efa18e413c7894ba92a2cc7505e22cbda202de14
RUN apt-get install zsh sudo -y && \
    rm -rf /var/lib/apt/lists/* && \
    chsh -s /bin/zsh mark && \
    git clone http://${TOKEN}@adccgit.francecentral.cloudapp.azure.com:3000/MarcoT/Zsh /home/mark/.oh-my-zsh

# Install PowerFont
RUN mkdir -p /home/devel/.local/share/fonts/ && \
    mkdir -p /home/devel/.config/fontconfig/conf.d/ && \
    wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf -P /home/devel/.local/share/fonts/ && \
    wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf -P /home/devel/.config/fontconfig/conf.d/ && \
    fc-cache -vf /home/devel/.local/share/fonts/

# Time Zone
ENV LANGUAGE=en_US
RUN apt-get install locales locales-all -y && locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/* && \
    echo "Europe/Paris" > /etc/timezone && \
    apt-get install -y locales && \
    sed -i -e "s/# $LANG.*/$LANG.UTF-8 UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANGUAGE


# Nomachine - Installation
ENV NOMACHINE_PACKAGE_NAME nomachine_6.6.8_5_amd64.deb
ADD resources/${NOMACHINE_PACKAGE_NAME} /home/root/
RUN apt-get update && apt-get install -y vim xterm pulseaudio cups curl && \
    dpkg -i /home/root/${NOMACHINE_PACKAGE_NAME} && \
    /etc/NX/nxserver --start && \
    /etc/NX/nxserver --virtualgl yes

# Install CLion
ENV CLION=CLion-2019.1.4.tar.gz
RUN wget https://download.jetbrains.com/cpp/$CLION && \
    tar xvf $CLION && \
    echo 'alias clion=". /home/devel/${CLION}/bin/clion.sh"' >> /home/devel/.zshrc && \
    rm -rf $CLION


# # ROS2
# ENV ROS2_DISTRO=crystal
# # Add source
# RUN apt-get update && apt-get install curl gnupg2 lsb-release -y &&\
#     curl http://repo.ros2.org/repos.key | apt-key add - &&\
#     sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list' &&\
#     apt-get update && sudo apt upgrade -y


# Install sddm
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install sddm kde-plasma-desktop -y && \
    rm -rf /var/lib/apt/lists/*

# Add init scripts
ADD resources/init-container /usr/local/bin/
RUN chmod +x /usr/local/bin/init-container

# Permission to user and install zsh
RUN chown -R mark: /home/mark
USER mark
RUN bash /home/mark/.oh-my-zsh/install_zsh
# Init script
ADD resources/init-login.sh /usr/local/bin/
RUN echo "source /usr/local/bin/init-login.sh" >> /home/mark/.zshrc

WORKDIR /home/mark

## start
ENTRYPOINT ["/usr/local/bin/init-container"]
CMD /bin/zsh
