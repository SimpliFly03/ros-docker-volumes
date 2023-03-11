# This is an auto generated Dockerfile for ros:ros1-bridge
# generated from docker_images_ros2/ros1_bridge/create_ros_ros1_bridge_image.Dockerfile.em
FROM ghcr.io/autowarefoundation/autoware-universe:humble-latest-cuda-amd64

ENV ROS2_DISTRO humble
ENV ROS_DISTRO humble

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        gettext-base \
        locales \
        keyboard-configuration && \
    rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8; dpkg-reconfigure -f noninteractive locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

#RUN echo deb https://deb.nodesource.com/node_10.x ${CODENAME} main | tee /etc/apt/sources.list.d/nodesource.list
#RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key 1655A0AB68576280

COPY apt-packages /tmp/
RUN apt-get update && \
    apt-get install -y \
        $(cat /tmp/apt-packages | cut -d# -f1 | envsubst) \
    && rm -rf /var/lib/apt/lists/* /tmp/apt-packages


COPY bashrc-git-prompt /
RUN cat /bashrc-git-prompt >> /etc/skel/.bashrc && \
    rm /bashrc-git-prompt
COPY gdbinit /etc/gdb/

RUN apt-get update && apt-get install -y fonts-liberation libu2f-udev


# install ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-ros1-bridge \
    ros-humble-demo-nodes-cpp \
    ros-humble-demo-nodes-py \
    ros-humble-rqt-gui-py \
    ~nros-humble-rqt* \
    ros-humble-turtlesim && \
    rm -rf /var/lib/apt/lists/* && apt-get clean

RUN apt-get update && apt-get install -y software-properties-common nano && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get install -y python3.7 python3.7-venv && \
    apt-get remove -y mesa-vulkan-drivers && \
    apt-get install -y python3-opencv && \
    rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt-get update && apt-get install -y \
    python3-rosdep python3-rosinstall-generator python3-vcstool python3-rosinstall build-essential \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt-get update && apt-get install -y \
    iputils-ping avahi-daemon \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt-get update && apt-get install -y \
    libopencv-dev libqglviewer-dev-qt5 \
    freeglut3-dev qtbase5-dev \
    && rm -rf /var/lib/apt/lists/* && apt-get clean

RUN apt-get update && apt-get install -y wget gpg && \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg && \
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
    rm -f packages.microsoft.gpg && apt-get install -y apt-transport-https && apt-get update && apt-get install -y code \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt-get update && wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb && \
    apt-get update && apt-get install -y dotnet-sdk-6.0 aspnetcore-runtime-6.0 \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt-get update && apt-get install -y \
    can-utils libsocketcan-dev libsocketcan2 \
    ros-humble-ros2-socketcan \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt-get update && add-apt-repository -y ppa:slonopotamus/glibc-dso && apt-get update && \
    apt-get install --reinstall -y libc6-dbg libc6-i386 libc6-dev libc-dev-bin libc6 locales libc-bin \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
    

# Update
#RUN apt-get update && \
#    apt-get -y dist-upgrade && \
#    rm -rf /var/lib/apt/lists/* && apt-get clean

# setup entrypoint
#COPY ./ros_entrypoint.sh /
#RUN chmod +x /ros_entrypoint.sh

COPY env.sh /etc/profile.d/ade_env.sh
COPY gitconfig /etc/gitconfig
RUN echo "export COLCON_DEFAULTS_FILE=/usr/local/etc/colcon-defaults.yaml" >> \
    /etc/skel/.bashrc

## Create entrypoint
# hadolint ignore=DL3059
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" > /etc/bash.bashrc

# Auto start avahi
COPY start-avahi.sh /bin/start-avahi.sh
RUN chmod +x /bin/start-avahi.sh
RUN sed -i 's/\#enable\-dbus\=yes/enable\-dbus\=no/' /etc/avahi/avahi-daemon.conf
RUN echo "/bin/start-avahi.sh" >> /etc/bash.bashrc

RUN rm /etc/apt/apt.conf.d/docker-clean && apt-get update

CMD ["/bin/bash"]

