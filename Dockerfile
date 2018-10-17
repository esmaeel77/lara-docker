FROM php:7.2

RUN apt-get update -yqq
RUN apt-get install -yqq \
    mysql-server \
    git \
    gnupg2 \
    libc-client-dev \
    libcurl4-gnutls-dev \
    libicu-dev \
    libmcrypt-dev \
    libvpx-dev \
    libjpeg-dev \
    libpng-dev \
    libxpm-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libxml2-dev \
    libexpat1-dev \
    libbz2-dev \
    libgmp3-dev \
    libldap2-dev \
    unixodbc-dev \
    libpq-dev \
    libsqlite3-dev \
    libaspell-dev \
    libsnmp-dev \
    libpcre3-dev \
    libtidy-dev

RUN echo "display_errors = Off
max_execution_time = 30
max_input_time = 60
max_input_vars = 1000
memory_limit = 1280M
post_max_size = 8M
upload_max_filesize = 2M
precision=14
serialize_precision=14" > /usr/local/etc/php/php.ini

# Compile PHP, include these extensions.
RUN docker-php-ext-install mbstring curl json intl gd xml zip bz2 ftp fileinfo sockets soap posix pgsql pdo_mysql iconv bcmath

#install mongodb php ext.
RUN pecl install mongodb
RUN echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongo.ini

#install geos
RUN apt-get install libgeos-dev -yqq
RUN git clone https://git.osgeo.org/gitea/geos/php-geos.git
RUN cd php-geos
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install
RUN cd ..
RUN echo "extension=geos.so" > /usr/local/etc/php/conf.d/geos.ini

# Install Composer and project dependencies.
RUN curl -sS https://getcomposer.org/installer | php
RUN php composer.phar install --no-plugins --no-scripts --dev
