FROM debian:wheezy

MAINTAINER Olivier Revollat <olivier@revollat.net>

ENV VERSION 0.2.5.10

RUN apt-get update
RUN apt-get install -y curl build-essential libevent-dev libssl-dev vim procps

ENV HOME /home/tor
RUN groupadd -g 1000 tor 
RUN useradd -u 1000 -g 1000 -c "The Onion Router" -d ${HOME} -s /bin/bash tor
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

WORKDIR ${HOME}
#CMD bin/tor -f etc/torrc
CMD ["bin/tor","-f","etc/torrc"]
