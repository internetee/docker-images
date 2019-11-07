FROM ruby:2.5-slim-buster

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update > /dev/null && apt-get install -y --no-install-recommends > /dev/null \
    build-essential=* \
    imagemagick=* \
    curl \
    wget \
    gnupg2 \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc -s | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update > /dev/null && apt-get install -y --no-install-recommends > /dev/null \
    postgresql-client-9.4=* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# add repository for Node.js in the LTS version
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get install -y --no-install-recommends > /dev/null \
  nodejs=* \
  qt5-default=* \
  libqt5webkit5-dev=* \
  gstreamer1.0-plugins-base=* \
  libappindicator3-1=* \
  gstreamer1.0-tools=* \
  libasound2=* \
  libnspr4=* \
  libnss3=* \
  libxss1=* \
  libxtst6=* \
  xdg-utils=* \
  qtdeclarative5-dev=* \
  fonts-liberation=* \
  gstreamer1.0-x=* \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN curl https://chromedriver.storage.googleapis.com/2.46/chromedriver_linux64.zip -o /chromedriver_linux64.zip
RUN apt-get update > /dev/null \
    && apt-get install -yf --no-install-recommends > /dev/null unzip=* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN unzip chromedriver_linux64.zip -d /usr/local/bin
RUN rm /chromedriver_linux64.zip

RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
RUN dpkg -i /chrome.deb || apt-get update > /dev/null \
    && apt-get install -yf --no-install-recommends > /dev/null && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN dpkg -i /chrome.deb
RUN rm /chrome.deb

RUN mkdir -p /opt/webapps/app/tmp/pids
WORKDIR /opt/webapps/app
EXPOSE 3000
