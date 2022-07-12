# Create a disposable container:
#docker run -it --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro -e DISPLAY=$(ifconfig en0 | grep "inet " | sed 's/.*inet //g' | cut -d' ' -f1):0 --name netbeans jcreyf/netbeans:12.1

# Create a persistent container:
#docker create -v /Users/JCREYF/data/:/data/ \
#              -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro \
#              -e DISPLAY=$(ifconfig en0 | grep "inet " | sed 's/.*inet //g' | cut -d' ' -f1):0 \
#              --name netbeans \
#              jcreyf/netbeans:12.1

# Start the persistent container:
docker container start netbeans

# Open a shell to the running container:
docker exec -it netbeans /bin/bash