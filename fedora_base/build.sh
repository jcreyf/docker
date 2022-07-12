#
# Script to build the base Fedora image.
# There's no specific software in this image and is meant to be used as foundation
# for other images, so there should be no need to create a container from this image.
#

# Docker CLI doc:
#   https://docs.docker.com/engine/reference/commandline/build/

# Generate the docker image:
docker build --tag jcreyf/fedora_base:33 .

# To start a container instance of this image:
#   -i   == --interactive (keep the container running even if there are no apps running in it)
#   -t   == --tty (immediately open a shell into the container)
#   -d   == --detached (daemon) (it will stop automatically if there's no app running in the container)
#   --rm == automatically destroy the container when done running
# /> docker run -i -d --name fc33 jcreyf/fedora_base:33

# Want to create a container; run a command; then stop again and remove container?
# /> docker run --rm -it --name "fc33_temp" jcreyf/fedora_base:33 "<cmd>"

# Want to run a command in a running container:
# /> docker exec fc33 /bin/sh -c "<command"

# Open a terminal to a running container (load bash if installed, otherwise sh):
# /> docker exec -it fc33 /bin/sh -c "[ -e /bin/bash ] && /bin/bash || /bin/sh"