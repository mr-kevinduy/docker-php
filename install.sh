#!/usr/bin/env bash

apt update
apt upgrade -y
apt install -y --no-install-recommends lsb-release ca-certificates apt-transport-https software-properties-common locales

locale-gen en_US.UTF-8

echo "LANGUAGE=en_US.UTF-8" >> /etc/default/locale
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
echo "LC_CTYPE=UTF-8" >> /etc/default/locale

export LANG=en_US.UTF-8

add-apt-repository ppa:ondrej/php -y
apt update
apt install -y --no-install-recommends --allow-downgrades --allow-remove-essential --allow-change-held-packages \
  php8.1 \
  php8.1-dev \
  php8.1-fpm \
  php8.1-common \
  php8.1-xml \
  php8.1-xmlrpc \
  php8.1-curl \
  php8.1-dev \
  php8.1-cli \
  php8.1-gd \
  php8.1-bcmath \
  php8.1-pdo \
  php8.1-imap \
  php8.1-soap \
  php8.1-zip \
  php8.1-mbstring \
  php8.1-imagick \
  php8.1-opcache \
  php8.1-redis \
  php8.1-mysql \
  php8.1-pgsql \
  php8.1-sqlite3 \
  php8.1-xdebug \
  php8.1-intl

apt install -y --no-install-recommends --allow-downgrades --allow-remove-essential --allow-change-held-packages \
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

apt install -y --no-install-recommends --allow-downgrades --allow-remove-essential --allow-change-held-packages \
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

# Install MCrypt
# printf "\n" | pecl install mcrypt-1.0.4
# bash -c "echo extension=mcrypt.so > /etc/php/8.1/mods-available/mcrypt.ini"
# bash -c "echo extension=/usr/lib/php/20200930/mcrypt.so > /etc/php/8.0/cli/conf.d/mcrypt.ini"
# bash -c "echo extension=/usr/lib/php/20200930/mcrypt.so > /etc/php/8.0/apache2/conf.d/mcrypt.ini"

# apt install -y nginx
# ufw allow 'Nginx HTTP'

# Remove load xdebug extension
sed -i 's/^/;/g' /etc/php/8.1/cli/conf.d/20-xdebug.ini

# Set FPM
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
apt install -y nodejs
npm install -g yarn parcel-bundler gulp-cli

# ============ Clean up
# apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
