FROM debian:stretch

# Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# PHP
RUN apt-get update && \
    # libapache2-mod-php7.0: INSTALL php7.0-cli php7.0-common php7.0-json php7.0-opcache php7.0-readline
    apt-get install -y libapache2-mod-php7.0 php7.0-curl php7.0-dev php7.0-gd php7.0-mbstring php7.0-mysql \
    php7.0-sqlite3 php7.0-tidy php7.0-xml php7.0-xmlrpc php7.0-zip \
    git && \
    chsh -s /bin/bash

# Tideways
# @see https://tideways.com/profiler/xhprof-for-php7
RUN cd /tmp && \
    git clone "https://github.com/tideways/php-xhprof-extension.git" && \
    cd php-xhprof-extension && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf php-xhprof-extension && \
    echo "extension=tideways_xhprof.so" > /etc/php/7.0/mods-available/tideways_xhprof.ini && \
    ln -s /etc/php/7.0/mods-available/tideways_xhprof.ini /etc/php/7.0/apache2/conf.d/30-tideways_xhprof.ini

# Mongodb
RUN pecl install mongodb && \
    echo "extension=mongodb.so" > /etc/php/7.0/mods-available/mongodb.ini && \
    ln -s /etc/php/7.0/mods-available/mongodb.ini /etc/php/7.0/apache2/conf.d/20-mongodb.ini && \
    ln -s /etc/php/7.0/mods-available/mongodb.ini /etc/php/7.0/cli/conf.d/20-mongodb.ini

# Xhgui
RUN git clone https://github.com/perftools/xhgui.git /var/www/xhgui && \
    chmod -R 0777 /var/www/xhgui/cache && \
    cd tmp && \
    curl -sS https://getcomposer.org/installer > composer-setup.php && \
    php composer-setup.php --filename=composer && \
    mv composer /bin/composer && \
    rm composer-setup.php && \
    cd /var/www/xhgui && \
    composer install --prefer-dist && \
    cp config/config.default.php config/config.php

WORKDIR /srv
COPY ./srv /srv

ENTRYPOINT ["/tini", "-g", "--", "/srv/run.sh"]
CMD "/srv/run.sh"
