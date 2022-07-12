#
# Create the Apache Netbeans image for java development:
#
ARG FEDORA_VERSION=33
ARG NETBEANS_VERSION=12.1
ARG JAVA_VERSION=1.8.0
ARG USER=jcreyf

# Start from our own Fedora Base image for this version:
FROM jcreyf/fedora_gui:${FEDORA_VERSION:-34}

# Add environment variables to the image for use downstream:
ENV NETBEANS_VERSION=12.1    \
    JAVA_VERSION=1.8.0       \
    RACFID=jcreyf
ENV USER_HOME=/home/${RACFID}
# This does not seem to work for some reason :(
#   ENV NETBEANS_VERSION=${NETBEANS_VERSION} \
#       JAVA_VERSION=${JAVA_VERSION}         \
#       USER=${USER}

# Add metadata to the Docker image:
LABEL "Provider"="Jo Creyf"                     \
      "Maintainer"="jo.creyf@gmail.com"         \
      "OS"="Fedora"                             \
      "OS_Version"=${FEDORA_VERSION}            \
      "Application"="Apache Netbeans"           \
      "ApplicationVersion"=${NETBEANS_VERSION}  \
      "JavaVersion"=${JAVA_VERSION}

# Install JDK and other dependent packages:
RUN dnf install --assumeyes \
      java-${JAVA_VERSION}-openjdk \
      java-${JAVA_VERSION}-openjdk-devel

# Switch to the app user for the app installation:
USER ${RACFID}
WORKDIR ${USER_HOME}

# Copy the installer and scripts to the image:
# (there are several ways of installing through different package managers but a direct download seems to work best)
#ARG NETBEANS_INSTALLER="Apache-NetBeans-${NETBEANS_VERSION}-bin-linux-x64.sh"
COPY --chown=${RACFID}:${RACFID} ./files/*.sh ${USER_HOME}/
RUN chmod +x ${USER_HOME}/*.sh ; \
    ${USER_HOME}/install.sh

# Start the IDE:
ENTRYPOINT ["/home/jcreyf/entrypoint.sh"]
# This does not seem to work :((
#   ENTRYPOINT [${USER_HOME}"/entrypoint.sh"]
