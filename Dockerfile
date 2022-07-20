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


# install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-melodic-desktop-full=1.4.1-0* \
    software-properties-common nano htop \
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
CMD ["/bin/bash"]

