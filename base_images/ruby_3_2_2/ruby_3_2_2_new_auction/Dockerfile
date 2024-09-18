FROM ruby:3.2.2-slim-bookworm

ARG NODE_VER=18

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install essential packages and dependencies
RUN apt-get update > /dev/null && apt-get install -y --no-install-recommends > /dev/null \
    build-essential \
    imagemagick \
    curl \
    wget \
    gnupg2 \
    git \
    apt-utils \
    nano \
    && apt-get dist-upgrade -yf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install locales
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

# Configure locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && sed -i -e 's/# et_EE.UTF-8 UTF-8/et_EE.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=et_EE.UTF-8
ENV LANG=et_EE.UTF-8

# Add PostgreSQL repository for version 13 using gpg dearmor and install it
RUN mkdir -p /usr/share/keyrings \
    && curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/postgresql-archive-keyring.gpg] http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql-client-13 \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add Node.js repository and install Node.js and Yarn
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VER}.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g yarn@latest

# Install additional dependencies for Capybara Webkit and other tools
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    qtbase5-dev \
    libqt5webkit5-dev \
    gstreamer1.0-plugins-base \
    libappindicator3-dev \
    gstreamer1.0-tools \
    qtdeclarative5-dev \
    gstreamer1.0-x \
    libasound2 \
    libnspr4 \
    libnss3 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    wkhtmltopdf \
    libxslt1-dev \
    libxml2-dev \
    python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /opt/webapps/app/tmp/pids
WORKDIR /opt/webapps/app
EXPOSE 3000
