Usage
=====

1/ In the Dockerfile make sure that UID and GID is the same as your user (you can find out with the "```id```" command)
So we can mount the config file "torrc" and the ".tor" directory in the container without privileges problems.

2/ Build the image 

```docker build -t torbox .```

3/ If you want, you can customize tor config (```torrc``` file) 

* Nickname
* bandwidth
* ports number  ... o make your relay work make sure the configured ORPort is accessible from outside comment ORPort line it if you don't want a relay and just want to use the tor proxy.

4/
Run the container 

```docker run --name=torbox --net=host -it -v $PWD/dottor:/home/tor/.tor -v $PWD/torrc:/home/tor/etc/torrc torbox```

Customization
=============

If you want to reload the config after any change in the torrc:

```docker exec -it torbox bash``` (works only with docker 1.3)

... and in the container send a HUP signal to the tor process

```pgrep -f tor | xargs kill -HUP```
