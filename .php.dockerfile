FROM ubuntu:16.04

RUN set -ex; \
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

# nginx basic conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY siteavailable.conf /etc/nginx/sites-available/default

# tweak php.ini configuration
RUN set -ex; \
    sed -i -e 's~.*expose_php = .*~expose_php = Off~' /etc/php/7.2/fpm/php.ini ; \
    sed -i -e 's~.*date.timezone =.*~date.timezone = "UTC"~' /etc/php/7.2/fpm/php.ini ; \
    sed -i -e 's~.*session.cookie_httponly =.*~session.cookie_httponly = 1~' /etc/php/7.2/fpm/php.ini ; \
    sed -i -e 's~.*session.use_trans_sid =.*~session.use_trans_sid = 0~' /etc/php/7.2/fpm/php.ini ; \
    sed -i -e 's~.*default_charset = .*~default_charset = "UTF-8"~' /etc/php/7.2/fpm/php.ini ; \
    sed -i -e 's~display_errors = .*~display_errors = Off~' /etc/php/7.2/fpm/php.ini ; \
    sed -i -e 's/error_reporting = .*/error_reporting = E_ALL \& ~E_NOTICE \& ~E_WARNING \& ~E_DEPRECATED \& ~E_STRICT/' /etc/php/7.2/fpm/php.ini ; \
    sed -i -e 's~upload_max_filesize = .*~upload_max_filesize = 16M~' /etc/php/7.2/fpm/php.ini ; \
    sed -i -e 's~post_max_size = .*~post_max_size = 16M~' /etc/php/7.2/fpm/php.ini ; \
    sed -i -e 's~.*mail.add_x_header = .*~mail.add_x_header = Off~' /etc/php/7.2/fpm/php.ini ; \
    sed -i -e 's~;catch_workers_output = .*~catch_workers_output = yes~' /etc/php/7.2/fpm/pool.d/www.conf ; \
    sed -i -e 's~;clear_env = no~clear_env = no~' /etc/php/7.2/fpm/pool.d/www.conf ; \
    rm -f /etc/nginx/sites-enabled/default ; \
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default \
    ;

# Install Composer and make it available in the PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer && \
  mkdir -p /var/run/php /etc/supervisor/conf.d /var/log/supervisor /var/www/html/vendor /var/www/html/demox && \
  chown -R www-data.www-data /var/www && \
  chown www-data.www-data /var/log/supervisor && \
  chmod +x /usr/local/bin/composer

# Set locales
RUN locale-gen en_US.UTF-8

# Switch to use a non-root user from here on
USER www-data

WORKDIR /var/www/html/

# Copy composer files into the app directory.
COPY --chown=www-data composer.json ./
COPY --chown=www-data demox ./demox
COPY --chown=www-data cfg.php ./demox

# Install dependencies with Composer.
# --prefer-source fixes issues with download limits on Github.
# --no-interaction makes sure composer can run fully automated
RUN composer install --prefer-source --no-interaction

USER root

#Install supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
