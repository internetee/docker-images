FROM ruby:2.3.7-jessie
MAINTAINER maciej.szlosarczyk@internet.ee

RUN apt-get update > /dev/null && apt-get install -y > /dev/null \
    build-essential \
    nodejs \
    imagemagick \
    postgresql-client-9.4 \

RUN apt-get install -y > /dev/null \
    qt5-default \
    libqt5webkit5-dev \
    gstreamer1.0-plugins-base \
    gstreamer1.0-tools \
    qtdeclarative5-dev \
    gstreamer1.0-x \
    xvfb

RUN mkdir -p /opt/webapps/app/tmp/pids
WORKDIR /opt/webapps/app
EXPOSE 3000
