# This is an auto generated Dockerfile for ros:ros1-bridge
# generated from docker_images_ros2/ros1_bridge/create_ros_ros1_bridge_image.Dockerfile.em
FROM registry.gitlab.com/autowarefoundation/autoware.auto/autowareauto/amd64/ade-foxy:master

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros1-latest.list

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

ENV ROS1_DISTRO noetic
ENV ROS2_DISTRO foxy
ENV ROS_DISTRO foxy

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
    ros-foxy-ros1-bridge \
    ros-foxy-demo-nodes-cpp \
    ros-foxy-demo-nodes-py \
    ros-foxy-rqt-gui-py \
    ros-foxy-derived-object-msgs \
    ~nros-foxy-rqt* && \
    rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt get install -y software-properties-common nano htop && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get install -y python3.7 python3.7-venv && \
    apt-get remove -y mesa-vulkan-drivers && \
    apt-get install -y python3-opencv && \
    rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt-get update && apt-get install -y \
    python3-rosdep python3-rosinstall-generator python3-vcstool python3-rosinstall build-essential \
    ros-noetic-catkin python3-catkin-tools \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
    
RUN apt-get update && apt-get install -y \
    iputils-ping avahi-daemon \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
    
    
# Auto start avahi
COPY start-avahi.sh /bin/start-avahi.sh
RUN chmod +x /bin/start-avahi.sh
RUN sed -i 's/\#enable\-dbus\=yes/enable\-dbus\=no/' /etc/avahi/avahi-daemon.conf
RUN echo "/bin/start-avahi.sh" >> /etc/bash.bashrc

# Update
#RUN apt-get update && \
#    apt-get -y dist-upgrade && \
#    rm -rf /var/lib/apt/lists/* && apt-get clean

# setup entrypoint
#COPY ./ros_entrypoint.sh /
#RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ade_entrypoint"]
CMD ["/bin/sh", "-c", "trap 'exit 147' TERM; tail -f /dev/null & wait ${!}"]

