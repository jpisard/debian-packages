FROM ubuntu:16.04

MAINTAINER "Davide Madrisan" <d.madrisan@gmail.com>

WORKDIR /usr/local

# development environment for golang projects
RUN apt-get --quiet update \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y \
          git        \
          wget       \
          debhelper  \
          devscripts \
          dh-systemd \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/*

# development environment for python projects
RUN apt-get --quiet update \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y \
          dh-python   \
          python-all  \
          python3-all \
          python-setuptools  \
          python3-setuptools \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/*

RUN mkdir -p \
    /opt/bin            \
    /opt/build          \
    /opt/share/packages 

COPY build-packages-wrapper.sh /opt/bin/
COPY buildrules/* /opt/share/packages/

RUN chmod 755 /opt/bin/build-packages-wrapper.sh

ENTRYPOINT ["/opt/bin/build-packages-wrapper.sh"]
