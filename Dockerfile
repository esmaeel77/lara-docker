FROM centos:7.5.1804

RUN yum update -y
RUN yum -y install epel-release
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum -y install yum-utils
RUN yum-config-manager --enable remi-php72
RUN yum update -y

RUN yum -y install \
    gcc-c++ \
    make \
    git \
    mysql \
    gnupg2 \
    libc-client \
    libicu \
    libmcrypt \
    libvpx \
    libjpeg \
    libpng \
    libXpm \
    unixODBC \
    which \
    libtidy

RUN yum -y install \
    php \
    php-mbstring \
    php-intl \
    php-gd \
    php-xml \
    php-zip \
    php-soap \
    php-posix \
    php-pgsql \
    php-pdo_mysql \
    php-bcmath \
    php-mongodb \
    php-geos \
    php-xdebug


RUN printf "display_errors=Off\nmax_execution_time=30\nmax_input_time=60\nmax_input_vars=1000\nmemory_limit=1280M\npost_max_size=8M\nupload_max_filesize=2M\nprecision=14\nserialize_precision=14" >> /etc/php.ini

ENV COMPOSER_HOME /usr/local/share/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH "$COMPOSER_HOME:$COMPOSER_HOME/vendor/bin:$PATH"
RUN mkdir -pv $COMPOSER_HOME
RUN chmod -R g+w $COMPOSER_HOME
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer
RUN curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig
RUN php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) \
    !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); \
    echo 'Invalid installer' . PHP_EOL; exit(1); }"
RUN php /tmp/composer-setup.php --filename=composer --install-dir=$COMPOSER_HOME

RUN composer global require laravel/envoy

RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash -
RUN curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
RUN yum -y install \
    nodejs \
    yarn
