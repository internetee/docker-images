FROM debian:wheezy
MAINTAINER maciej.szlosarczyk@internet.ee

RUN apt-get update > /dev/null && apt-get install -y > /dev/null \
    build-essential \
    apache2 \
    apache2-threaded-dev

RUN mkdir -p /opt/webapps/apache
COPY patches /opt/webapps/apache
WORKDIR /opt/webapps/apache/mod_epp-1.10
RUN apxs2 -a -c -i mod_epp.c

RUN rm -r /etc/apache2/sites-enabled

RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod headers
RUN a2enmod ssl

WORKDIR /etc/apache2
EXPOSE 80
EXPOSE 443
