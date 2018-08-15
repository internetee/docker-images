FROM ruby:2.4.4-jessie
MAINTAINER maciej.szlosarczyk@internet.ee

RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    imagemagick \
    postgresql-client-9.4

RUN apt-get install -y \
  qt5-default \
  libqt5webkit5-dev \
  gstreamer1.0-plugins-base \
  libappindicator3-1 \
  gstreamer1.0-tools \
  qtdeclarative5-dev \
  gstreamer1.0-x \
  fonts-liberation \
  libgconf2-4

RUN wget https://chromedriver.storage.googleapis.com/2.40/chromedriver_linux64.zip
RUN apt-get install -yf unzip
RUN unzip chromedriver_linux64.zip -d /usr/local/bin

RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
RUN dpkg -i /chrome.deb || apt-get install -yf
RUN dpkg -i /chrome.deb

RUN mkdir -p /opt/webapps/app/tmp/pids
WORKDIR /opt/webapps/app
EXPOSE 3000
