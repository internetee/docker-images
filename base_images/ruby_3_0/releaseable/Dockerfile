FROM ruby:3.0.2-slim-bullseye
# NodeJS version
ARG NODE_VER=14
# Yarn version
ARG YARN_VER='1.22.10'

RUN apt-get update  -y > /dev/null && apt-get install -y --no-install-recommends > /dev/null \
    build-essential=* \
    imagemagick=* \
    curl \
    libxml2-dev \
    git \
    locales \
    wkhtmltopdf \
    libpq-dev

# Install Estonian locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# et_EE.UTF-8 UTF-8/et_EE.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=et_EE.UTF-8

ENV LANG et_EE.UTF-8

# add repository for Node.js in the LTS version
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VER}.x | bash -
RUN apt-get install -y --no-install-recommends > /dev/null \
  nodejs=*
RUN npm install -g yarn@"$YARN_VER"

# upgrade system
RUN apt-get dist-upgrade -yf\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /opt/webapps/app
EXPOSE 3000
