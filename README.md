# docker-php
Docker for php, composer, linux packages, nodejs, yarn, parcel-bundler and gulp-cli.

`docker pull kevinduy/php`

# 1. Main

- kevinduy/php:8.2 (kevinduy/php:latest)
- kevinduy/php:8.1
- kevinduy/php:8.0
- kevinduy/php:2.0
- kevinduy/php:1.0

# 2. Docker-compose

- __docker-compose.yml__:

```yaml
version: "3"

services:
  workspace:
    image: kevinduy/php
    tty: true
    restart: always
    volumes:
      - ./:/var/www/app
```

- __Running docker compose__:

```sh
docker-compose up -d

# Linux
docker-compose exec workspace bash

# Windows
winpty docker-compose exec workspace bash
```

- Development build and update new version of image
```sh
cd /path/to/docker-php
docker rmi kevinduy/php:latest
docker build -t kevinduy/php:8.2 .
docker push kevinduy/php:8.2
docker tag kevinduy/php:8.2 kevinduy/php:latest
docker push kevinduy/php:latest

git add .
git commit -m "v8.2"
git push origin php82
```

# 3. Changelog

### [V8.2]
- Ubuntu 22.04
- php 8.2
- nodejs 20.x
- npm
- yarn
- composer v2
- fpm
- supervisor
- support. for laravel 9x and above.
- php config:
  + display_errors = On
  +.memory_limit = 512M
  + post_max_size = 500M
  + upload_max_filesize = 500M

### [V8.1]
- Ubuntu 22.04
- php 8.1
- nodejs 16.x
- npm
- yarn
- composer v2
- fpm
- supervisor
- support. for laravel 9x
- php config:
  + display_errors = On
  +.memory_limit = 512M
  + post_max_size = 500M
  + upload_max_filesize = 500M

### [V8.0]
- Ubuntu 20.04
- php 8.1
- nodejs 14.x
- composer v2
- fpm
- supervisor
- support. for laravel 9x
- php config:
  + display_errors = On
  +.memory_limit = 512M
  + post_max_size = 500M
  + upload_max_filesize = 500M

### [V2.0]
- php 7.3
- nodejs 12.x
- composer v1
- fpm
- supervisor
- support. for laravel 8x, 7x, 6x, 5x, ...
- php config:
  + display_errors = On
  +.memory_limit = 512M
  + post_max_size = 500M
  + upload_max_filesize = 500M

### [V1.0]
- php 7.2
- nodejs 8.x
- composer v1
- fpm
- supervisor
- for laravel <= 7.x
- php config:
  + display_errors = On
  +.memory_limit = 512M
  + post_max_size = 50M
  + upload_max_filesize = 50M
