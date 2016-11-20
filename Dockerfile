#
# Scala, sbt and Selenium (with Firefox) Dockerfile
#
# https://github.com/pending...
#

# Pull base image
FROM hseeberger/scala-sbt

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV FIREFOX_VERSION 40.0.3

#==============
# VNC and Xvfb (Virtual Frame Buffer to run test headlessly)
#==============
RUN apt-get update -qqy \
  && apt-get -qqy install xvfb \
  && rm -rf /var/lib/apt/lists/*

#==============
# Firefox
#==============
RUN apt-get update -qqy \
  && rm -rf /var/lib/apt/lists/* \
  && wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
  && rm -rf /opt/firefox \
  && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
  && rm /tmp/firefox.tar.bz2 \
  && mv /opt/firefox /opt/firefox-$FIREFOX_VERSION \
  && ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox

#============================
# GTK3 (required by Firefox 46+)
#============================
RUN apt-get update -qqy \
    && apt-get install -qqy libgtk-3-0

# Define working directory
WORKDIR /root

