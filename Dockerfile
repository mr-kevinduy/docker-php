FROM ubuntu:20.04

MAINTAINER KevinDuy <mr.kevinduy@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install packages
ADD install.sh /install.sh

RUN chmod +x /*.sh

RUN /install.sh

ADD supervisor.conf /etc/supervisor/conf.d/supervisor.conf

RUN usermod -u 1000 www-data

CMD ["/usr/bin/supervisord"]

WORKDIR /var/www/app

EXPOSE 9000
