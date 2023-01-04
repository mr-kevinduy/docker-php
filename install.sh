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
  php7.4 \
  php7.4-dev \
  php7.4-fpm \
  php7.4-common \
  php7.4-xml \
  php7.4-xmlrpc \
  php7.4-curl \
  php7.4-dev \
  php7.4-cli \
  php7.4-gd \
  php7.4-bcmath \
  php7.4-pdo \
  php7.4-imap \
  php7.4-soap \
  php7.4-zip \
  php7.4-mbstring \
  php7.4-imagick \
  php7.4-opcache \
  php7.4-redis \
  php7.4-mysql \
  php7.4-pgsql \
  php7.4-sqlite3 \
  php7.4-xdebug \
  php7.4-intl

apt install -y --no-install-recommends --allow-downgrades --allow-remove-essential --allow-change-held-packages \
  gcc \
  g++ \
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
# bash -c "echo extension=mcrypt.so > /etc/php/7.4/mods-available/mcrypt.ini"
# bash -c "echo extension=/usr/lib/php/20200930/mcrypt.so > /etc/php/8.0/cli/conf.d/mcrypt.ini"
# bash -c "echo extension=/usr/lib/php/20200930/mcrypt.so > /etc/php/8.0/apache2/conf.d/mcrypt.ini"

# apt install -y nginx
# ufw allow 'Nginx HTTP'

# Remove load xdebug extension
sed -i 's/^/;/g' /etc/php/7.4/cli/conf.d/20-xdebug.ini

# Set FPM
sed -i "s/listen =.*/listen = 0.0.0.0:9000/" /etc/php/7.4/fpm/pool.d/www.conf
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 1024M/" /etc/php/7.4/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 512M/" /etc/php/7.4/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 1024M/" /etc/php/7.4/fpm/php.ini
sed -i "s/max_execution_time = .*/max_execution_time = 300/" /etc/php/7.4/fpm/php.ini
mkdir -p /var/run/php
mkdir -p /var/log/php-fpm
touch /var/run/php/php7.4-fpm.sock

# ============ Install Composer, PHPCS
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
composer global require "squizlabs/php_codesniffer=*"

# Create symlink
ln -s /root/.composer/vendor/bin/phpcs /usr/bin/phpcs

# ============ Install nodejs
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs
npm install -g yarn

# ============ Clean up
# apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
