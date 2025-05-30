FROM ubuntu:20.04

ENV TZ=Australia/Sydney
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add some args for creating user
ARG USERNAME=useruser
ARG HOME_DIR=/home/$USERNAME

# Add user
# Best practise: don't run as root in container and ensure USERNAME appears in prompt
# uid has to match id of repo owner on host. Ensures you don't get locked out of your own folder while inside the container
# Has to correspond to the id of the user that owns the folder being mounted from the host into the container
RUN useradd --uid 1001 --home-dir $HOME_DIR --create-home $USERNAME

# Create a default password for the user and make him a sudoer. Variables won't be interpretad inside '', so use "" instead.
RUN echo "$USERNAME:password" | chpasswd && adduser $USERNAME sudo

# Obtain all relevant packages
RUN apt-get update && \
    apt-get install -y sudo cmake wget bash zip git rsync build-essential software-properties-common ca-certificates xvfb geany nano

# Get Python and relevant libraries
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip python3.8-dev
RUN pip install --upgrade pip

RUN mkdir -p $HOME_DIR/git/cbf_diff_sq
COPY . $HOME_DIR/git/cbf_diff_sq
WORKDIR $HOME_DIR/git/cbf_diff_sq
RUN pip install .[comparative_studies]

# Make the user the owner of their home directory
RUN chown -R $USERNAME $HOME_DIR

# ==================================================================
# ROS
# ------------------------------------------------------------------
# RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list' && \
#     apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
#     apt-get update && apt-get install -y --allow-unauthenticated ros-melodic-desktop
# RUN apt-get update -y
# RUN apt-get install -y --allow-unauthenticated python-rosinstall python-rosdep python-vcstools python-catkin-tools ros-melodic-ros-numpy ros-melodic-rospy ros-melodic-roslib

# RUN python -m pip install rospkg

# bootstrap rosdep
# RUN rosdep init
# RUN rosdep update


# ==================================================================
# config & cleanup
# ------------------------------------------------------------------
RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*

# Start an interactive container as $USER instead of ROOT
USER $USERNAME

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["bash"]
