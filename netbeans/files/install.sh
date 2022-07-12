#!/bin/bash
#
# Installation script to setup software in the container
#


# The docker build process should have copied the Netbeans installer.
# Lets check and execute:
INSTALLER=$(ls Apache-NetBeans*.sh)

if [ $? -eq 0 ] ; then
  # Ok, we have an installer.  Lets execute it...
  echo "Executing the installer (${INSTALLER})..."
  ./${INSTALLER} --silent
  # Go find where the binary was installed and add to the PATH environment variable:
  # (this of course assumes that we have findutils installed in the base image!!!)
  APP=$(find ~+ -type f -name netbeans)
  echo "Netbeans found at: ${APP}"
  echo "export PATH=${PATH}:${APP}" >> ~/.bashrc
  # Also add to the entrypoint.sh script:
  echo "${APP}" >> entrypoint.sh
  echo "Install success!"
  # Remove the large installer file from the container!
  rm ${INSTALLER}
else
  # No installer found!
  # We have 2 options: cry like a baby or download from the web ourselves.
  # Lets cry like a baby
  #
  # An installer can be downloaded from the web like this:
  #  /> wget --no-check-certificate https://apache.claz.org/netbeans/netbeans/12.1/Apache-NetBeans-12.1-bin-linux-x64.sh
  echo "No NetBeans installer script found!"
  echo "Make sure to download one and copy in the host's ./files/ directory."
  echo "Then rebuild the docker image."
  echo "Install failed!"
  exit 1
fi
