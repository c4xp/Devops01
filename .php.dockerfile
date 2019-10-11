FROM ubuntu:16.04

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y inetutils-ping vim software-properties-common language-pack-en-base wget net-tools apt-utils supervisor cron mc git curl tree supervisor; \
    LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php; \
    apt-get update; \
    apt-get install -y php7.2 php7.2-fpm php7.2-common php7.2-mbstring php7.2-xmlrpc php7.2-gd php7.2-xml php7.2-sqlite3 php7.2-mysql php7.2-cli php7.2-zip php7.2-curl php7.2-ldap php7.2-soap; \
    apt-get install -y nginx autoconf build-essential libicu-dev libxslt-dev libmcrypt-dev libxml2-dev libcurl4-openssl-dev libmcrypt-dev mysql-client apt-utils ldap-utils libldap2-dev libc-client-dev libkrb5-dev libgmp-dev libgmp3-dev libfreetype6-dev libc6-dev libpng-dev libjpeg-dev libgd-dev openssl libmemcached-dev zlib1g-dev ssl-cert; \
    apt-get clean; \
    make-ssl-cert generate-default-snakeoil --force-overwrite; \
    rm -rf /var/lib/apt/lists/* \
    ;

# Install tools and applications through pear. Binaries will be accessible in your PATH.
#RUN pear install pear/PHP_CodeSniffer

# copy original php.ini configuration
#ADD php.ini /usr/local/etc/php

# tweak php.ini configuration
RUN sed -i -e 's~.*expose_php = .*~expose_php = Off~' /etc/php/7.2/fpm/php.ini && \
    sed -i -e 's~.*date.timezone =.*~date.timezone = "UTC"~' /etc/php/7.2/fpm/php.ini && \
    sed -i -e 's~.*session.cookie_httponly =.*~session.cookie_httponly = 1~' /etc/php/7.2/fpm/php.ini && \
    sed -i -e 's~.*session.use_trans_sid =.*~session.use_trans_sid = 0~' /etc/php/7.2/fpm/php.ini && \
    sed -i -e 's~.*default_charset = .*~default_charset = "UTF-8"~' /etc/php/7.2/fpm/php.ini && \
    sed -i -e 's~display_errors = .*~display_errors = Off~' /etc/php/7.2/fpm/php.ini && \
    sed -i -e 's/error_reporting = .*/error_reporting = E_ALL \& ~E_NOTICE \& ~E_WARNING \& ~E_DEPRECATED \& ~E_STRICT/' /etc/php/7.2/fpm/php.ini && \
    sed -i -e 's~upload_max_filesize = .*~upload_max_filesize = 16M~' /etc/php/7.2/fpm/php.ini && \
    sed -i -e 's~post_max_size = .*~post_max_size = 16M~' /etc/php/7.2/fpm/php.ini && \
    sed -i -e 's~.*mail.add_x_header = .*~mail.add_x_header = Off~' /etc/php/7.2/fpm/php.ini && \
    sed -i -e 's~;catch_workers_output = .*~catch_workers_output = yes~' /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i -e 's~;clear_env = no~clear_env = no~' /etc/php/7.2/fpm/pool.d/www.conf

# nginx basic conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY siteavailable.conf /etc/nginx/sites-available/default
RUN rm -f /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
#RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

# Install Composer and make it available in the PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Set locales
RUN locale-gen en_US.UTF-8

WORKDIR /var/www/html/

# Copy composer files into the app directory.
COPY composer.json ./

# Install dependencies with Composer.
# --prefer-source fixes issues with download limits on Github.
# --no-interaction makes sure composer can run fully automated
RUN composer install --prefer-source --no-interaction

COPY demox ./demox
RUN rm -f ./demox/cfg.php
COPY cfg.php ./demox/cfg.php

RUN chown -R www-data:www-data /var/www/html/demox

#Install supervisor
RUN mkdir -p /etc/supervisor/conf.d /var/run/php /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
