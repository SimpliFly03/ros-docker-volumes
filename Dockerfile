# This is an auto generated Dockerfile for ros:ros1-bridge
# generated from docker_images_ros2/ros1_bridge/create_ros_ros1_bridge_image.Dockerfile.em
FROM ros:melodic-perception-bionic

ENV ROS1_DISTRO melodic
ENV ROS_DISTRO melodic

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        gettext-base \
        locales \
        keyboard-configuration && \
    rm -rf /var/lib/apt/lists/* && apt-get clean
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
    && rm -rf /var/lib/apt/lists/* /tmp/apt-packages && apt-get clean


COPY bashrc-git-prompt /
RUN cat /bashrc-git-prompt >> /etc/skel/.bashrc && \
    rm /bashrc-git-prompt
COPY gdbinit /etc/gdb/

RUN apt-get update && apt-get install -y fonts-liberation libu2f-udev && \
    rm -rf /var/lib/apt/lists/* && apt-get clean


# install packages
RUN apt-get update && apt-get install -y --no-install-recommends ros-melodic-desktop-full=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt-get update && apt-get install -y \
    python-rosdep python-rosinstall-generator python-vcstool python-rosinstall build-essential \
    ros-melodic-catkin python-catkin-tools \
    && rm -rf /var/lib/apt/lists/* && apt-get clean

RUN apt-get update && apt-get install -y software-properties-common \
    nano htop python3-pip python3-setuptools \
    python3-pybind11 libtins-dev \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt-get update && apt-get install -y \
    cmake pkg-config mesa-utils libglu1-mesa-dev freeglut3-dev mesa-common-dev \
    libglew-dev libglfw3 libglfw3-dev libglm-dev \
    libao-dev libmpg123-dev \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt-get update && apt-get install -y \
    libopencv-dev libqglviewer-dev-qt5 freeglut3-dev qtbase5-dev \
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

RUN sed -i 's/files\ dns/files\ mdns\_minimal\ \[NOTFOUND\=return\]\ dns/' /etc/nsswitch.conf && \
    sed -i 's/\#enable\-dbus\=yes/enable\-dbus\=no/' /etc/avahi/avahi-daemon.conf

## Create entrypoint
# hadolint ignore=DL3059
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" > /etc/bash.bashrc

# Auto start avahi daemon only if it is not already started
COPY start-avahi.sh /bin/start-avahi.sh
RUN echo "/bin/start-avahi.sh" >> /etc/bash.bashrc

CMD ["/bin/bash"]

