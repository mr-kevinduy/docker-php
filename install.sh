#!/usr/bin/env bash

# ============ Update Package List
apt-get update
apt-get install -y --no-install-recommends apt-utils
apt-get install -y --no-install-recommends lsb-release ca-certificates apt-transport-https software-properties-common locales

locale-gen en_US.UTF-8

echo "LANGUAGE=en_US.UTF-8" >> /etc/default/locale
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
echo "LC_CTYPE=UTF-8" >> /etc/default/locale

export LANG=en_US.UTF-8

# ============ Add PPA php and Install PHP-CLI, some PHP extentions
apt-add-repository ppa:ondrej/php -y

# Bug: W: --force-yes is deprecated, use one of the options starting with --allow instead.
# Fix: --allow-downgrades --allow-remove-essential --allow-change-held-packages instead --force-yes
# Fix Issue: https://github.com/jontewks/puppeteer-heroku-buildpack/pull/30s
apt-get update
apt-get install -y --no-install-recommends --allow-downgrades --allow-remove-essential --allow-change-held-packages \
  php8.1 \
  php8.1-cli \
  php8.1-fpm \
  php8.1-dev \
  php8.1-common \
  php8.1-soap \
  php8.1-zip \
  php8.1-gd \
  php8.1-bcmath \
  php8.1-json \
  php8.1-mbstring \
  php8.1-curl \
  php8.1-xml \
  php8.1-pdo \
  php8.1-mysql \
  php8.1-pgsql \
  php8.1-sqlite \
  php8.1-sqlite3 \
  php8.1-xdebug \
  php8.1-intl \
  php-pear \
  php-memcached \
  php-redis \
  php-apcu

apt-get install -y --no-install-recommends --allow-downgrades --allow-remove-essential --allow-change-held-packages \
  gcc \
  make \
  autoconf \
  libc-dev \
  pkg-config \
  git \
  curl \
  vim \
  nano \
  tree \
  zip \
  unzip \
  supervisor

apt-get install -y --no-install-recommends --allow-downgrades --allow-remove-essential --allow-change-held-packages \
  libcurl4-openssl-dev \
  libedit-dev \
  libssl-dev \
  libxml2-dev \
  xz-utils \
  sqlite3 \
  libsqlite3-dev \
  libmcrypt-dev \
  libreadline-dev \
  libmagic-dev

apt-get update

# Installing mcrypt on PHP 8.1
# Note:
# mcrypt-1.0.1: PHP 7.2.0 -> PHP 7.3.0
# mcrypt-1.0.2: PHP 7.2.0 -> PHP 7.4.0
# mcrypt-1.0.3: PHP 7.2.0 -> PHP 8.0.0
printf "\n" | pecl install mcrypt-1.0.3
bash -c "echo extension=mcrypt.so > /etc/php/8.1/mods-available/mcrypt.ini"

printf "\n" | pecl install Fileinfo

# Remove load xdebug extension
sed -i 's/^/;/g' /etc/php/8.1/cli/conf.d/20-xdebug.ini

# Set php7.3-fpm
sed -i "s/listen =.*/listen = 0.0.0.0:9000/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.1/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.1/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 500M/" /etc/php/8.1/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 500M/" /etc/php/8.1/fpm/php.ini
mkdir -p /var/run/php
mkdir -p /var/log/php-fpm
touch /var/run/php/php8.1-fpm.sock

# ============ Install Composer, PHPCS
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
composer global require "squizlabs/php_codesniffer=*"

# Create symlink
ln -s /root/.composer/vendor/bin/phpcs /usr/bin/phpcs

# ============ Install nodejs
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs
npm install -g yarn parcel-bundler gulp-cli

# ============ Clean up
apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
