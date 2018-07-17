# PHP 7.2 base image
FROM php:7.2.3-alpine3.7

LABEL maintainer tobias@neontribe.co.uk
ARG SYSTEM_SITE_UUID=370cd9a3-dc8f-4fad-93cb-80c58f099de8

# Install PHP packages
RUN wget -O /tmp/composer-setup.php https://getcomposer.org/installer \
    && php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && apk --no-cache --virtual add \
        bash \
        curl-dev \
        freetype-dev \
        gettext-dev \
        icu-dev \
        libxml2-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        mysql \
        nodejs-npm \
        openldap-dev \
        sqlite \
        sqlite-dev \
    && docker-php-ext-configure \
        gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
        ctype \
        curl \
        dom \
        gd \
        gettext \
        iconv \
        intl \
        json \
        ldap \
        mbstring \
        pdo \
        pdo_mysql \
        pdo_sqlite \
        phar \
        posix \
        session \
        soap \
        tokenizer \
        xml \
        xmlrpc \
        xmlwriter \
        zip \
    && docker-php-ext-enable \
        ctype \
        curl \
        dom \
        gd \
        gettext \
        iconv \
        intl \
        json \
        ldap \
        mbstring \
        pdo \
        pdo_mysql \
        pdo_sqlite \
        phar \
        posix \
        session \
        soap \
        tokenizer \
        xml \
        xmlrpc \
        xmlwriter \
        zip \
    && rm /tmp/composer-setup.php \
    && rm -rf /var/lib/apt/lists/*

ENV PATH=${PATH}:/root/.composer/vendor/bin/


# Install Drush and its dependencies
RUN composer global require drush/drush:8 \
    && apk --no-cache --virtual add \
        build-base \
        git \
        libffi-dev \
        mysql-client \
        pngquant \
        ruby \
        ruby-dev \
        ruby-rdoc \
        ruby-irb \
        sqlite \
    && gem install listen sass compass \
    && apk del build-base libffi-dev ruby-dev \
&& rm -rf /var/cache/apk/*

# Install Drupal

WORKDIR /opt
COPY template3/drupal /opt/drupal
WORKDIR /opt/drupal
RUN composer install

RUN vendor/bin/drush \
    --no-ansi --pipe -q si -y \
    --db-url=sqlite://sites/default/files/.ht.sqlite \
    --account-pass=planetcrownceilingemerald

WORKDIR web/themes/custom/template3themes
RUN npm config set loglevel warn && npm install --global gulp && npm install && gulp
WORKDIR /opt/drupal

RUN vendor/bin/drush config-set "system.site" uuid "${SYSTEM_SITE_UUID}"
COPY drushrc.php /etc/drush/drushrc.php
RUN echo "\$settings['trusted_host_patterns'] = [ '^localhost$', '^127.0.0.1$', '^0.0.0.0$', '.*', '^goodlife.localhost$', ];" >> web/sites/default/settings.php

# Replace site wide drush/drupal with install specifics.
ENV PATH=/opt/drupal/vendor/bin:${PATH}
CMD ["/bin/bash"]

# docker build --rm -t neonkvm:5000/t3_base_drupal --no-cache -f Dockerfile.base .

# docker run -ti -p 8989:8989 --name t3-base --rm neonkvm:5000/t3_base_drupal
# docker exec -ti t3-base vendor/bin/drush upwd admin password=XXXXX # Won't persist
# docker exec -ti t3-base vendor/bin/drupal site:mode dev


