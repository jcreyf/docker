#
# Create a base Fedora image that has support for graphical user interfaces.
# So this image contains the base Fedora image + XOrg and Wayland packages.
#
ARG FEDORA_VERSION=33

# Start from our own Fedora Base image for this version:
FROM jcreyf/fedora_base:${FEDORA_VERSION:-34}

# Add metadata to the Docker image:
LABEL "Provider"="Jo Creyf"             \
      "Maintainer"="jo.creyf@gmail.com" \
      "OS"="Fedora"                     \
      "OS_Version"=${FEDORA_VERSION}

# Install a bunch of stuff to setup X in the image:
RUN sudo dnf install --assumeyes \
      xclock \
      xorg-x11-utils \
      xauth
