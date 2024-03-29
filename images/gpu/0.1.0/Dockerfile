

# Sector : DockerFlavor
#ubuntu 18.04
FROM ubuntu:18.04
LABEL maintainer "Markno1 - marco.treglia1@gmail.com"


# Sector : Devices
#Nvidia
# Install CUDA
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl && \
    rm -rf /var/lib/apt/lists/*
ENV CUDA_PKG_VERSION 10-1
ENV CUDA_VERSION 10.1.168
# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-compat-$CUDA_PKG_VERSION && \
    ln -s cuda-10.1 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*
# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411"


# Sector : Utils
#Basics
RUN   apt-get update && apt-get install -y tree htop bmon nano terminator apt-transport-https clang-format-6.0 git  openssh-server && \
      rm -rf /var/lib/apt/lists/*
#Ssh
RUN echo "X11UseLocalhost=no" >> /etc/ssh/sshd_config && \
    echo "Port 28" >> /etc/ssh/sshd_config


# Sector : Gui
#Sddm
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install sddm kde-plasma-desktop -y && \
    rm -rf /var/lib/apt/lists/*


# Sector : Tools
#CLion
ENV CLION=CLion-2019.1.4.tar.gz
RUN wget https://download.jetbrains.com/cpp/$CLION && \
    tar xvf $CLION && \
    echo 'alias clion=". /home/devel/${CLION}/bin/clion.sh"' >> /home/devel/.zshrc && \
    rm -rf $CLION
#Zsh
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
#NoMachine
# Nomachine - Installation
ENV NOMACHINE_PACKAGE_NAME nomachine_6.6.8_5_amd64.deb
ADD resources/${NOMACHINE_PACKAGE_NAME} /home/root/
RUN apt-get update && apt-get install -y vim xterm pulseaudio cups curl && \
    dpkg -i /home/root/${NOMACHINE_PACKAGE_NAME} && \
    /etc/NX/nxserver --start && \
    /etc/NX/nxserver --virtualgl yes


# Sector : Finalization
#Initial scripts
ADD resources/init-container /usr/local/bin/
RUN chmod +x /usr/local/bin/init-container
#Permission to the user and install zsh
# Permission to user and install zsh
RUN chown -R mark: /home/mark
USER mark
RUN bash /home/mark/.oh-my-zsh/install_zsh
# Init script
ADD resources/init-login.sh /usr/local/bin/
RUN echo "source /usr/local/bin/init-login.sh" >> /home/mark/.zshrc
#Starting folder
WORKDIR /home/mark#Entry script
ENTRYPOINT ["/usr/local/bin/init-container"]#Entry shell
CMD /bin/zsh