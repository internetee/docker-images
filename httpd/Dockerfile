FROM debian:jessie-backports
MAINTAINER maciej.szlosarczyk@internet.ee

RUN apt-get update > /dev/null && apt-get install -y > /dev/null \
    build-essential \
    apache2 \
    apache2-threaded-dev

RUN mkdir -p /opt/webapps/apache
COPY patches /opt/webapps/apache
WORKDIR /opt/webapps/apache/mod_epp-1.10
RUN apxs2 -a -c -i mod_epp.c

RUN a2enmod proxy_http
RUN mkdir /etc/apache2/ssl
RUN rm -r /etc/apache2/sites-enabled

RUN a2enmod proxy
RUN a2enmod proxy_http

COPY apache2/ssl /etc/apache2/ssl
COPY apache2/apache2.conf /etc/apache2/apache2.conf
COPY apache2/sites-enabled /etc/apache2/sites-enabled
COPY ssl/wildcard.localhost /etc/ssl/wildcard.localhost
RUN a2enmod ssl

WORKDIR /etc/apache2
