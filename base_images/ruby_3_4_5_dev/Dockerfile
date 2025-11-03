FROM ruby:3.4.5-bookworm

ARG NODE_VER=18

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update > /dev/null && apt-get install -y --no-install-recommends > /dev/null \
    apt-utils \
    build-essential \
    imagemagick \
    curl \
    wget \
    gnupg2 \
    git \
    && apt-get dist-upgrade -yf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN sed -i -e 's/# et_EE.UTF-8 UTF-8/et_EE.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=et_EE.UTF-8

ENV LANG="et_EE.UTF-8"

RUN echo "deb http://archive.debian.org/debian buster main" > /etc/apt/sources.list.d/buster.list
RUN echo "deb http://archive.debian.org/debian buster-updates main" >> /etc/apt/sources.list.d/buster.list
RUN echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list.d/buster.list

RUN echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

# Update package list and install dependencies
RUN apt-get update > /dev/null \
    && apt-get install -y --no-install-recommends libldap-2.4-2 libssl1.1

# Install PostgreSQL client 11 and libpq-dev
RUN apt-get update > /dev/null \
    && apt-get install -y --no-install-recommends postgresql-client-11 libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add repository for Node.js in the LTS version
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VER}.x | bash -

# Install other dependencies
RUN apt-get install -y --no-install-recommends \
  nodejs \
  libqt5webkit5-dev \
  gstreamer1.0-plugins-base \
  libappindicator3-1 \
  gstreamer1.0-tools \
  qtdeclarative5-dev \
  fonts-liberation \
  gstreamer1.0-x \
  libasound2 \
  libnspr4 \
  libnss3 \
  libxss1 \
  libxtst6 \
  xdg-utils \
  qtdeclarative5-dev \
  fonts-liberation \
  gstreamer1.0-x \
  wkhtmltopdf \
  libxslt1-dev \
  libxml2-dev \
  python-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# RUN curl https://chromedriver.storage.googleapis.com/2.46/chromedriver_linux64.zip -o /chromedriver_linux64.zip
# RUN apt-get update > /dev/null \
#     && apt-get install -yf --no-install-recommends unzip \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*
# RUN unzip chromedriver_linux64.zip -d /usr/local/bin
# RUN rm /chromedriver_linux64.zip

# RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
# RUN dpkg -i /chrome.deb || apt-get update > /dev/null \
#     && apt-get install -yf --no-install-recommends && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*
# RUN dpkg -i /chrome.deb
# RUN rm /chrome.deb
# RUN sed -i 's/SECLEVEL=2/SECLEVEL=1/' /etc/ssl/openssl.cnf

# Determine architecture and download appropriate Chrome version
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb; \
    elif [ "$ARCH" = "arm64" ]; then \
        echo "Chrome not officially available for arm64, using Chromium instead" && \
        apt-get update > /dev/null && \
        apt-get install -y --no-install-recommends chromium chromium-driver && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*; \
    fi

# Install Chrome if downloaded (amd64 only)
RUN if [ -f /chrome.deb ]; then \
        dpkg -i /chrome.deb || (apt-get update > /dev/null && \
        apt-get install -yf --no-install-recommends && apt-get clean && \
        rm -rf /var/lib/apt/lists/*) && \
        rm /chrome.deb; \
    fi

RUN mkdir -p /opt/webapps/app/tmp/pids
WORKDIR /opt/webapps/app
EXPOSE 3000

