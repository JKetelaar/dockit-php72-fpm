FROM phpdockerio/php72-fpm:latest

MAINTAINER Jeroen Ketelaar version: 0.1

WORKDIR "/application"

ARG DEBIAN_FRONTEND=noninteractive

ENV LOCALE en_US.UTF-8

ENV TZ=Europe/Amsterdam

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8

RUN \
    sed -i -e "s/# $LOCALE/$LOCALE/" /etc/locale.gen \
    && echo "LANG=$LOCALE">/etc/default/locale \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=$LOCALE

RUN \
    apt-get -yqq install \
    apt-utils \
    build-essential \
    debconf-utils \
    debconf \
    mysql-client \
    curl \
    git \
    software-properties-common

RUN \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update

RUN \
    apt-get -yqq install \
    php7.2 \
    php7.2-curl \
    php7.2-bcmath \
    php7.2-bz2 \
    php7.2-dev \
    php7.2-gd \
    php7.2-dom \
    php7.2-imap \
    php7.2-imagick \
    php7.2-intl \
    php7.2-json \
    php7.2-ldap \
    php7.2-mbstring	\
    php7.2-mysql \
    php7.2-oauth \
    php7.2-odbc \
    php7.2-uploadprogress \
    php7.2-ssh2 \
    php7.2-xml \
    php7.2-zip \
    php7.2-solr \
    php7.2-apcu \
    php7.2-opcache \
    php7.2-memcache \
    php7.2-memcached \
    php7.2-redis \
    php7.2-xdebug

RUN \
    echo $TZ | tee /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    echo "date.timezone = \"$TZ\";" > /etc/php/7.2/fpm/conf.d/timezone.ini && \
    echo "date.timezone = \"$TZ\";" > /etc/php/7.2/cli/conf.d/timezone.ini

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN \
    curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -

ENV PATH /usr/local/go/bin:$PATH

RUN \
    go get github.com/mailhog/mhsendmail

RUN \
    cp /root/go/bin/mhsendmail /usr/bin/mhsendmail
