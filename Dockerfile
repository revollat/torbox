FROM debian:wheezy

MAINTAINER Olivier Revollat <olivier@revollat.net>

ENV VERSION 0.2.5.10

RUN apt-get update
RUN apt-get install -y curl build-essential libevent-dev libssl-dev vim

ENV HOME /home/tor
RUN groupadd -g 220 tor 
RUN useradd -u 220 -g 220 -c "The Onion Router" -d ${HOME} -s /bin/bash tor
RUN mkdir -p ${HOME}
RUN chown -R tor:tor ${HOME}

USER tor
RUN curl https://dist.torproject.org/tor-${VERSION}.tar.gz | tar xz -C /tmp
WORKDIR /tmp/tor-${VERSION}
RUN ./configure \
  --prefix=${HOME} \
  --exec-prefix=${HOME} \
  --with-tor-user=tor \
  --with-tor-group=tor \
  --datadir=${HOME}

RUN make && make install
RUN rm -rf /tmp/tor-${VERSION}

USER root
ADD start-tor.sh /start-tor
ADD ./torrc /home/tor/etc/torrc
RUN echo "Nickname tor$(head -c 16 /dev/urandom  | sha1sum | cut -c1-10)" >> ${HOME}/etc/torrc
#RUN echo "User tor" >> ${HOME}/etc/torrc
RUN chown tor:tor /home/tor/etc/torrc

# Allow you to upgrade your relay without having to regenerate keys
VOLUME ${HOME}/.tor

WORKDIR ${HOME}

CMD ["bash", "/start-tor"]
