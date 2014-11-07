Usage
=====

1/ In the Dockerfile make sure that UID and GID is the same as your user (you can find out with the "```id```" command)
So we can mount the config file "torrc" and the ".tor" directory in the container without privileges problems.

2/ Build the image

```docker build -t torbox .```

3/ If you want, you can customize tor config (```torrc``` file)

* Nickname
* bandwidth
* ports number  ... to make your relay work, make sure the configured ORPort is accessible from outside, comment ORPort line it if you don't want a relay and just want to use the tor proxy.

4/
Run the container :

docker run -dt --name=torbox --net=host -v /etc/localtime:/etc/localtime:ro -v $PWD/dottor:/home/tor/.tor -v $PWD/torrc:/home/tor/etc/torrc torbox

In case you get an error with the previous command, you should delete the previous exited torbox container, because the container already exist with the same name, so just do :

```docker ps -a --filter 'status=exited' | grep torbox | awk '{print $1}' | xargs --no-run-if-empty docker rm```

Stopping tor service
====================

To stop torbox, just do a :

```docker torbox stop```

Check the logs
==============

```docker logs torbox```

Reload the configuration while running
======================================

If you want to reload the config after any change in the torrc:

```docker exec -it torbox bash``` (works only with docker 1.3)

... and in the container send a HUP signal to the tor process

```pgrep -f tor | xargs kill -HUP```

Use arm (https://www.atagar.com/arm/) monitor tool
==================================================

1/ generate a password to allow arm monitoring tool to communicate with tor via TorControl
While your torbox container is running, do :

```docker exec -it torbox bin/tor --hash-password mystrongpassword1234```

Oobviously use a stronger password :) You will get something like :

```16:E093DB61ADB04B8A606D0B0635C5AF4CB8EAB997B97CA88AAA3D20CAED```

2/ Edit your ```torrc``` and uncomment the following lines, and put you hased password on the ```HashedControlPassword``` line :

```
HashedControlPassword 16:E093DB61ADB04B8A606D0B0635C5AF4CB8EAB997B97CA88AAA3D20CAED
ControlPort 9151
DisableDebuggerAttachment 0
```
3/ Run arm with :

docker exec -it torbox bash

and then :

arm -i 9151

Put the password you used before to generate a hash, and enjoy :)
