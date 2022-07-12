# ./files/

<u><b>Apache-NetBeans-<version>-bin-linux-x64.sh</b></u>:<br>
This directory contains local copies of the large Netbeans installer files and script files to run in the container.<br>
The NetBeans installer files are typically over 300MB and can take too long to download.<br>
They don't change that often, so there's no need to download them each time we make a change to this docker image.  We'll just store a local copy here once and use that over and over again until a new release becomes available.<br>

We download them from:<br>
https://apache.claz.org/netbeans/netbeans/<br>
<br>
Example:<br>
https://apache.claz.org/netbeans/netbeans/12.1/Apache-NetBeans-12.1-bin-linux-x64.sh<br>
<br>

<u><b>Other files</b></u>:<br>
- <b>install.sh</b>: this script is copied to the container and is executed to install NetBeans;
- <b>entrypoint.sh</b>: this script is run everytime the docker container is started.  It starts the NetBeans IDE;
