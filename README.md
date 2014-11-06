In the Dockerfile make sure that UDI and GID is the same as your user (you can find out with the "id" command)
So we can mount the config file "torrc" and the ".tor" direcotry in the container without privileges problems.

Build the image
docker build -t torbox .

customize torrc (Nicknamei, bandwidth, port nunber if you want ...) and make sure the configured ORPort is accessible from outside if you want to make a relay or comment it if you don't want

Run the container
docker run --name=torbox --net=host -it -v $PWD/dottor:/home/tor/.tor -v $PWD/torrc:/home/tor/etc/torrc torbox

If you want to reload the config after any change in the torrc:

docker exec -it torbox bash
pgrep -f tor | xargs kill -HUP
