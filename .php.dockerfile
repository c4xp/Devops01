FROM php:7.3-fpm-alpine3.12

ENV PHP_INI_FILE="/etc/php7/php.ini" \
    PHP_FPM_CONF="/etc/php7/php-fpm.d/www.conf" \
    TZ="Etc/UTC" \
    COMPOSER_ALLOW_SUPERUSER="1" \
    COMPOSER_HOME="/root/.composer"

RUN set -ex; \
    apk update ; \
    apk add --no-cache \
    tzdata zip unzip openssl ca-certificates nginx tar mysql-client supervisor haveged rng-tools msmtp gmp \
    php7 php7-fpm php7-cli php7-common php7-opcache \
    php7-bcmath php7-ctype php7-curl php7-dom php7-fileinfo php7-gd php7-gmp php7-iconv php7-intl php7-exif php7-json php7-mbstring php7-mysqli php7-openssl php7-pdo php7-pdo_mysql php7-phar php7-posix php7-session php7-memcached php7-shmop php7-simplexml php7-tokenizer php7-xml php7-xmlreader php7-xmlwriter php7-zip php7-zlib ; \
    update-ca-certificates ; \
    rm -rf /var/cache/apk/* ; \
    rm -rf /tmp/* \
    ;

# nginx basic conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY siteavailable.conf /etc/nginx/conf.d/default.conf

# tweak php.ini configuration
RUN sed -i -e 's~.*expose_php = .*~expose_php = Off~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*date.timezone =.*~date.timezone = "UTC"~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*allow_url_fopen = .*~allow_url_fopen = Off~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*session.cookie_httponly =.*~session.cookie_httponly = 1~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*session.use_trans_sid =.*~session.use_trans_sid = 0~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*session.use_strict_mode =.*~session.use_strict_mode = 1~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*session.use_cookies =.*~session.use_cookies = 1~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*session.use_only_cookies =.*~session.use_only_cookies = 1~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*session.cookie_samesite =.*~session.cookie_samesite = "Lax"~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*default_charset = .*~default_charset = "UTF-8"~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*display_errors = .*~display_errors = Off~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*display_startup_errors = .*~display_startup_errors = Off~' ${PHP_INI_FILE} && \
    sed -i -e 's/error_reporting = .*/error_reporting = E_ALL \& ~E_NOTICE \& ~E_WARNING \& ~E_DEPRECATED \& ~E_STRICT/' ${PHP_INI_FILE} && \
    sed -i -e 's~upload_max_filesize = .*~upload_max_filesize = 32M~' ${PHP_INI_FILE} && \
    sed -i -e 's~post_max_size = .*~post_max_size = 32M~' ${PHP_INI_FILE} && \
    sed -i -e 's~max_execution_time = .*~max_execution_time = 120~' ${PHP_INI_FILE} && \
    sed -i -e 's~memory_limit = .*~memory_limit = 128M~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*open_basedir =.*~open_basedir = "/var/lib/php:/var/www:/root:/usr/local/bin:/tmp"~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*cgi.fix_pathinfo=.*~cgi.fix_pathinfo=0~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*opcache.enable=.*~opcache.enable=1~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*opcache.interned_strings_buffer=.*~opcache.interned_strings_buffer=64~' ${PHP_INI_FILE} && \
    sed -i -e 's~.*disable_functions =.*~disable_functions = pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wifcontinued,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_get_handler,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,pcntl_async_signals,exec,passthru,shell_exec,system,popen,parse_ini_file,show_source,escapeshellarg,escapeshellcmd~' ${PHP_INI_FILE} && \
    sed -i -e 's~;catch_workers_output = .*~catch_workers_output = yes~' ${PHP_FPM_CONF} && \
    sed -i -e 's~.*listen.backlog =.*~listen.backlog = 1024~' ${PHP_FPM_CONF} && \
    sed -i -e 's~.*clear_env = no~clear_env = no~' ${PHP_FPM_CONF} && \
    sed -i -e "s~.*user =.*~user = nobody~" ${PHP_FPM_CONF} && \
    sed -i -e "s~.*group =.*~group = nobody~" ${PHP_FPM_CONF} && \
    sed -i -e "s~.*listen\.owner =.*~listen\.owner = nobody~" ${PHP_FPM_CONF} && \
    sed -i -e "s~.*listen\.group =.*~listen\.group = nobody~" ${PHP_FPM_CONF} && \
    sed -i -e "s~.*listen\.mode =.~listen\.mode = 0660~" ${PHP_FPM_CONF} && \
    sed -i -e 's~.*listen = .*~listen = /run/php-fpm.sock~' ${PHP_FPM_CONF}

# Install Composer and make it available in the PATH
RUN chown -R nobody.nobody /run && \
  openssl req -x509 -sha256 -newkey rsa:1024 -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt -days 3650 -nodes -subj '/CN=localhost' && \
  chmod 0644 /etc/ssl/certs/localhost.crt && \
  chmod 0600 /etc/ssl/private/localhost.key && \
  chown nobody.nobody /var/log/php7 && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx && \
  mkdir -p /var/www/html/app/application/vendor && mkdir -p /var/log/supervisor && mkdir -p /var/www/vendor && mkdir -p /root/.composer/cache/files && mkdir -p /root/.composer/cache/repo && \
  chown -R nobody.nobody /var/www && \
  chown -R nobody:nobody /var/lib/nginx && \
  chown nobody.nobody /var/log/supervisor && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Make the document root a volume
WORKDIR /var/www/html
#RUN composer install --prefer-dist --no-scripts --no-dev --no-autoloader && rm -rf /root/.composer

# Switch to use a non-root user from here on
#USER nobody

# If you make the assumption that you change your codebase more often than your Composer dependencies — then your Dockerfile should run composer install before copying across your codebase. This will mean that your composer install layer will be cached even if your codebase changes. The layer will only be invalidated when you actually change your dependencies.
COPY --chown=nobody:nobody . /var/www/html
COPY --chown=nobody:nobody cfg.php /var/www/html/demox

#RUN composer dump-autoload --no-scripts --no-dev --optimize

USER root

#Install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]