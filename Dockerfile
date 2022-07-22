# This is an auto generated Dockerfile for ros:ros1-bridge
# generated from docker_images_ros2/ros1_bridge/create_ros_ros1_bridge_image.Dockerfile.em
FROM ghcr.io/autowarefoundation/autoware-universe:galactic-latest-cuda-amd64

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros1-latest.list

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

ENV ROS1_DISTRO noetic
ENV ROS2_DISTRO galactic
ENV ROS_DISTRO galactic

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


# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-ros-comm \
    ros-noetic-desktop \
    ros-noetic-desktop-full \
    ros-noetic-roscpp-tutorials \
    ros-noetic-rospy-tutorials \
    && rm -rf /var/lib/apt/lists/* && apt-get clean

# install ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-galactic-ros1-bridge \
    ros-galactic-demo-nodes-cpp \
    ros-galactic-demo-nodes-py \
    ros-galactic-rqt-gui-py \
    ~nros-galactic-rqt* && \
    rm -rf /var/lib/apt/lists/* && apt-get clean

RUN apt-get update && apt-get install -y software-properties-common nano && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get install -y python3.7 python3.7-venv && \
    apt-get remove -y mesa-vulkan-drivers && \
    apt-get install -y python3-opencv && \
    apt-get install -y ~nros-galactic-rqt* && \
    rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt-get update && apt-get install -y \
    python3-rosdep python3-rosinstall-generator python3-vcstool python3-rosinstall build-essential \
    ros-noetic-catkin python3-catkin-tools \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt-get update && apt-get install -y \
    iputils-ping avahi-daemon \
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
RUN sed -i 's/\#enable\-dbus\=yes/enable\-dbus\=no/' /etc/avahi/avahi-daemon.conf
RUN echo "/bin/start-avahi.sh" >> /etc/bash.bashrc

CMD ["/bin/bash"]

