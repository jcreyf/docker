#
# Create a base Fedora image:
#
ARG FEDORA_VERSION=33
ARG USER=jcreyf

# Pull Fedora Core from Docker Hub (defaults to version 34 if version is not set):
FROM fedora:${FEDORA_VERSION:-34}

# Add metadata to the Docker image:
LABEL "Provider"="Jo Creyf"             \
      "Maintainer"="jo.creyf@gmail.com" \
      "OS"="Fedora"                     \
      "OS_Version"=${FEDORA_VERSION}

# Set some environment variables:
ENV RACFID=jcreyf

# Create a new user:
#   see /etc/default/useradd in the base image for default values
RUN useradd -s /bin/bash -r ${RACFID}

# Copy the config for the user:
COPY --chown=${RACFID} ./files/.bash* /home/${RACFID}/
COPY ./files/sudoers.d/10_${RACFID} /etc/sudoers.d/
COPY --chown=${RACFID} ./files/ssh/* /home/${RACFID}/.ssh/
# Set the permissions and create the /data directory:
RUN chmod -R 700 /home/${RACFID}/.ssh ; \
    mkdir -p /data && chgrp ${RACFID} /data && chmod 770 /data

# Add RPMFusion repository and install some tools that we need in all images:
#   https://rpmfusion.org/
RUN sudo dnf install --assumeyes \
      https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
      https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
      hostname \
      git \
      wget \
      findutils
