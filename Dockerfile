FROM debian:wheezy

MAINTAINER Olivier Revollat <olivier@revollat.net>

ENV VERSION 0.2.5.10

RUN groupadd -g 220 tor 
RUN useradd -u 220 -g 220 -c "The Onion Router" -d /home/tor -s /bin/false tor

RUN apt-get update
RUN apt-get install -y curl build-essential libevent-dev libssl-dev

RUN curl https://dist.torproject.org/tor-${VERSION}.tar.gz | tar xz -C /tmp

RUN cd /tmp/tor-${VERSION} && ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --with-tor-user=tor --with-tor-group=tor
RUN cd /tmp/tor-${VERSION} && make
RUN cd /tmp/tor-${VERSION} && make install
RUN rm -rf /tmp/tor-${VERSION}

ADD ./torrc /etc/tor/torrc

# Generate a random nickname for the relay
RUN echo "Nickname tor$(head -c 16 /dev/urandom  | sha1sum | cut -c1-10)" >> /etc/tor/torrc
#RUN echo "User tor" >> /etc/tor/torrc

# Allow you to upgrade your relay without having to regenerate keys
#VOLUME /home/tor/.tor

#RUN mkdir -p /var/lib/tor
#RUN mkdir -p /var/log/tor
RUN mkdir -p /home/tor
#RUN chown -R tor:tor /var/lib/tor
RUN chown -R tor:tor /etc/tor/
#RUN chown -R tor:tor /var/log/tor
RUN chown -R tor:tor /home/tor

#EXPOSE 9150

USER tor
WORKDIR /home/tor
CMD /usr/bin/tor -f /etc/tor/torrc
