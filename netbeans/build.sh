#
# Script to download the NetBeans installer from the web if we don't have one
# local yet and run the Docker build.
#
NETBEANS_VERSION="12.1"

echo "------------"
echo "Building the image..."

# See if we have an installer for this version of Netbeans:
INSTALLER=$(ls ./files/Apache-NetBeans-${NETBEANS_VERSION}-*.sh)

if [ $? -eq 0 ] ; then
  # Ok, we have an installer.  No need to do anything...
  echo "We have an installer: ${INSTALLER}"
else
  # No installer found!
  # Lets download one from the web:
  URL="https://apache.claz.org/netbeans/netbeans/${NETBEANS_VERSION}/Apache-NetBeans-${NETBEANS_VERSION}-bin-linux-x64.sh"
  cd files
  wget --no-check-certificate ${URL}
  if [ $? -eq 0 ] ; then
    # The download was successful.
    # Build the image...
    echo "The installer download was succesful!"
    echo "Source: ${URL}"
    cd ..
  else
    # The download failed!!!
    echo "The download failed!!!"
    exit 1
  fi
fi

# Docker CLI doc:
#   https://docs.docker.com/engine/reference/commandline/build/
# Generate the docker image:
docker build --tag jcreyf/netbeans:${NETBEANS_VERSION} .

# The Netbeans IDE is a graphical app that needs X-forwarding from the docker container
# to the host!
# This is no problem out of the box in Linux hosts since that comes with X out of the box
# but MacOS and Windows are not that easy since neither of them support X out of the box!
# We need to install some X-Server app(s) on Mac / Windows to get that support.
# Install XQuartz on a Mac and set:
#   X11 Preferences - Security - "Authenticate Connections" + "Allow connections from network clients"
#
# The winning commands to get X-forwarding on Mac with XQuartz:
# /> ifconfig en0 | grep "inet "
#	inet 192.168.43.211 netmask 0xffffff00 broadcast 192.168.43.255
# /> docker run -it --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro -e DISPLAY=192.168.43.211:0 --name test jcreyf/netbeans:33
#
# Automated:
# /> /usr/local/bin/docker run -it --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro -e DISPLAY=$(ifconfig en0 | grep "inet " | sed 's/.*inet //g' | cut -d' ' -f1):0 --name test jcreyf/netbeans:33
#   [root@8c085bcaeb7f /]# echo $DISPLAY
#   192.168.43.211:0
#   [root@8c085bcaeb7f /]# xclock

# Run the image as a disposable container:
#docker run -it --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro -e DISPLAY=$(ifconfig en0 | grep "inet " | sed 's/.*inet //g' | cut -d' ' -f1):0 --name netbeans jcreyf/netbeans:12.1

echo "------------"
echo "Creating a container from this image..."
echo "X to be forwarded to:"
echo $(ifconfig en0 | grep "inet " | sed 's/.*inet //g' | cut -d' ' -f1):0

# Create a persistent container:
docker create -v /Users/JCREYF/data/:/data/ \
              -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro \
              -e DISPLAY=$(ifconfig en0 | grep "inet " | sed 's/.*inet //g' | cut -d' ' -f1):0 \
              --name netbeans \
              jcreyf/netbeans:${NETBEANS_VERSION}

echo "------------"
echo "All done"

# Start the container (which also starts the Netbeans IDE):
#docker container start -a netbeans

# The IP address of the host may have changed since we created the container!  Make sure we keep this dynamic!
# Netbeans starts as soon as the container starts en the container stops when Netbeans is closed:
#docker run -it -e DISPLAY=$(ifconfig en0 | grep "inet " | sed 's/.*inet //g' | cut -d' ' -f1):0 --name netbeans

# Copy a file from the Docker container to the local filesysem:
# /> docker cp 8a0a4b03ba57:/tmp/Apache-NetBeans-12.1-bin-linux-x64.sh .
