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
  php8.4 \
  php8.4-dev \
  php8.4-fpm \
  php8.4-common \
  php8.4-xml \
  php8.4-xmlrpc \
  php8.4-curl \
  php8.4-dev \
  php8.4-cli \
  php8.4-gd \
  php8.4-bcmath \
  php8.4-pdo \
  php8.4-imap \
  php8.4-soap \
  php8.4-zip \
  php8.4-mbstring \
  php8.4-imagick \
  php8.4-opcache \
  php8.4-redis \
  php8.4-mysql \
  php8.4-pgsql \
  php8.4-sqlite3 \
  php8.4-xdebug \
  php8.4-intl

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

# Remove load xdebug extension
sed -i 's/^/;/g' /etc/php/8.4/cli/conf.d/20-xdebug.ini

# Set FPM
sed -i "s/listen =.*/listen = 0.0.0.0:9000/" /etc/php/8.4/fpm/pool.d/www.conf
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.4/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 1024M/" /etc/php/8.4/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 500M/" /etc/php/8.4/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 500M/" /etc/php/8.4/fpm/php.ini
mkdir -p /var/run/php
mkdir -p /var/log/php-fpm
touch /var/run/php/php8.4-fpm.sock

# ============ Install Composer, PHPCS
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
composer global require "squizlabs/php_codesniffer=*"

# Create symlink
# ln -s /root/.composer/vendor/bin/phpcs /usr/bin/phpcs

# Add PATH env for global composer vendor bin
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> "$HOME/.bashrc"

# ============ Clean up
# apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

