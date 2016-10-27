#
# Scala, sbt and Selenium (with Firefox & geckodriver) Dockerfile
#
# https://github.com/pending...
#

# Pull base image
FROM hseeberger/scala-sbt

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
# We need to use this version (v0.10.0 will throw error: Found argument '--webdriver-port' which wasn't expected, or isn't valid in this context)
ENV DRIVER_VERSION 2.24

#==============
# VNC and Xvfb (Virtual Frame Buffer to run test headlessly)
#==============
RUN apt-get update -qqy \
  && apt-get -qqy install xvfb \
  && rm -rf /var/lib/apt/lists/*

#==============
# Install Chromium
#==============
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y google-chrome-stable && \
  rm -rf /var/lib/apt/lists/*

#==============
# ChromeDriver
#==============
RUN wget --no-verbose -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$DRIVER_VERSION/chromedriver_linux64.zip \
  && rm -rf /opt/chromedriver \
  && unzip /tmp/chromedriver.zip -d /opt \
  && rm /tmp/chromedriver.zip \
  && mv /opt/chromedriver /opt/chromedriver-$DRIVER_VERSION \
  && chmod 755 /opt/chromedriver-$DRIVER_VERSION \
  && ln -fs /opt/chromedriver-$DRIVER_VERSION /usr/local/bin/chromedriver

#============================
# GTK3 (required by Firefox 46+)
#============================
RUN apt-get update -qqy \
    && apt-get install -qqy libgtk-3-0


#==============================
# Scripts to add User
#==============================
RUN useradd -ms /bin/bash newuser
USER newuser


#==============================
# Scripts to run Selenium Node
#==============================
RUN chown -R newuser:newuser /home/newuser
COPY before_tests.sh /home/newuser
USER root
RUN mkdir /tmp/.X11-unix
RUN chmod 1777 /tmp/.X11-unix
RUN chmod +x /home/newuser/before_tests.sh
USER newuser

#==============================
# Scripts to set workdir
#==============================
WORKDIR /home/newuser


