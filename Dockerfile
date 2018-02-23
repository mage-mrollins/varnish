FROM debian:latest

ARG VERSION="5.2.1"
ARG EXPOSE_PORT="80"

RUN apt-get update \
 && apt-get install -y \
 automake \
 autotools-dev \
 curl \
 graphviz \
 gcc \
 libedit-dev \
 libjemalloc-dev \
 libncurses-dev \
 libpcre3-dev \
 libtool \
 make \
 pkg-config \
 python-docutils \
 python-sphinx \
 && curl -sSL https://varnish-cache.org/_downloads/varnish-${VERSION}.tgz | tar -xz \ 
 && mv /varnish-${VERSION} /opt/varnish \
 && cd /opt/varnish \
 && sh autogen.sh \
 && sh configure \
 && make \
 && make install \
 && apt-get remove -y \
 automake \
 autotools-dev \
 graphviz \
 libedit-dev \
 libncurses-dev \
 libpcre3-dev \
 libtool \
 make \
 pkg-config \
 python-docutils \
 python-sphinx \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -fr /var/cache/apt \
 && rm -fr /opt/varnish

# Expose port 80
EXPOSE ${EXPOSE_PORT}

# Expose volumes to be able to use data containers
VOLUME ["/var/lib/varnish", "/etc/varnish"]

ADD start.sh /start.sh
CMD ["/start.sh"]
