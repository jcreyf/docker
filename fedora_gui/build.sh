#
# Script to build the base Fedora image that supports graphical user interfaces through XOrg.
# There's no specific software in this image and is meant to be used as foundation
# for other images, so there should be no need to create a container from this image.
#

# Docker CLI doc:
#   https://docs.docker.com/engine/reference/commandline/build/

# Generate the docker image:
docker build --tag jcreyf/fedora_gui:33 .

#
# There are special requirements to create a container since we need to setup X.
#

# On Linux, you may have run this to allow x-clients to connect to the local x-server:
#   /> xhost +

# Make sure to have XQuartz (X Org client emulator) installed on a Mac host:
#    (https://www.xquartz.org)
#     /> brew cask install xquartz
#   Then start:
#     /> open -a XQuartz
#   In X11 Preferences - Security:
#      check "Allow connections from network clients"
# Also install socat (bidirectional byte stream tool) on the Mac host:
#     (https://linux/die.net/man/1/socat)
#     /> brew install socat
#              A CA file has been bootstrapped using certificates from the system keychain. To add additional certificates, place .pem files in:
#                /usr/local/etc/openssl@1.1/certs
#              and run
#                /usr/local/opt/openssl@1.1/bin/c_rehash
#              openssl@1.1 is keg-only, which means it was not symlinked into /usr/local, because macOS provides LibreSSL.
#              If you need to have openssl@1.1 first in your PATH run:
#                echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"' >> /Users/JCREYF/.bash_profile
#   Then add a listener to port 6000:
#     /> socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
#   Get the IP address of your Mac:
#     />  ifconfig | grep "inet "
#           inet 192.168.1.93 netmask 0xffffff00 broadcast 192.168.1.255
#   Now start your container:
#docker run --rm -d -e DISPLAY=192.168.1.93:0 --name xeyes jcreyf/fedora_gui:33

# To start a container instance of this image:
#   -i   == --interactive (keep the container running even if there are no apps running in it)
#   -t   == --tty (immediately open a shell into the container)
#   -d   == --detached (daemon) (it will stop automatically if there's no app running in the container)
#   --rm == automatically destroy the container when done running
# /> docker run -i -d --name fc33 jcreyf/fedora_gui:33
# docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --name fcg33 jcreyf/fedora_gui:33
#docker container run --rm -it --env="DISPLAY" --net=host --name fg33 jcreyf/fedora_gui:33
#docker run --rm -d -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro -e DISPLAY=$DISPLAY --name xeyes jcreyf/fedora_gui:33
#docker run --rm -it --name fc33 jcreyf/fedora_gui:33

#----------
#docker build --tag jcreyf/fedora_gui:33 .
#docker create -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro --name fcg33 jcreyf/fedora_gui:33
#docker start fcg33
#docker logs -f fcg33
#docker exec -ti fcg33 /bin/bash
#ls -lia /tmp/.X11-unix/
# xhost +
# xauth generate :0 . trusted
# xauth -vvv generate /private/tmp/com.apple.launchd.TrWy9uhtwX/org.macosforge.xquartz:0 . trusted

#----------
# /> echo $DISPLAY; ssh -X localhost 'echo $DISPLAY'
#      /private/tmp/com.apple.launchd.TrWy9uhtwX/org.macosforge.xquartz:0
#      X11 forwarding request failed
#
# APFAMD6T292E6F:/etc/ssh
#  -rw-r--r--   1 root  wheel    1614 Nov 18 15:20 ssh_config
#  -rw-r--r--   1 root  wheel    1614 Nov 20 19:55 ssh_config_JCREYF_ORIG
#  -rw-r--r--   1 root  wheel    3268 Nov 18 15:20 sshd_config
#
# To restart the sshd daemon on the Mac host:
#   sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist
#   sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist
# or
#   sudo launchctl stop com.openssh.sshd
#   sudo launchctl start com.openssh.sshd
#
#----------
# build the image from Dockerfile:
#docker build --tag jcreyf/fedora_gui:33 .
# create a container from this image:
#docker create -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro --name fcg33 jcreyf/fedora_gui:33
# start the container:
#docker start -ia fcg33
#----------

# Want to create a container; run a command; then stop again and remove container?
# /> docker run --rm -it --name "fc33_temp" jcreyf/fedora_gui:33 "<cmd>"

# Want to run a command in a running container:
# /> docker exec fc33 /bin/sh -c "<command"

# Open a terminal to a running container (load bash if installed, otherwise sh):
# /> docker exec -it fc33 /bin/sh -c "[ -e /bin/bash ] && /bin/bash || /bin/sh"

# ------------------
# The winning commands:
# /> ifconfig | grep "inet "
#	inet 127.0.0.1 netmask 0xff000000
#	inet 192.168.43.211 netmask 0xffffff00 broadcast 192.168.43.255
#	inet 10.202.152.186 --> 10.202.152.186 netmask 0xffffc000
# /> /usr/local/bin/docker run -it --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro -e DISPLAY=192.168.43.211:0 --name test jcreyf/fedora_test:33
#
# Automated:
# /> /usr/local/bin/docker run -it --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro -e DISPLAY=$(ifconfig en0 | grep "inet " | sed 's/.*inet //g' | cut -d' ' -f1):0 --name test jcreyf/fedora_gui:33
#   [root@8c085bcaeb7f /]# echo $DISPLAY
#   192.168.43.211:0
#   [root@8c085bcaeb7f /]# xclock

# Run a volatile container (destroys itself after it's stopped):
# docker run -it --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro -e DISPLAY=$(ifconfig en0 | grep "inet " | sed 's/.*inet //g' | cut -d' ' -f1):0 --name test jcreyf/fedora_gui:33
