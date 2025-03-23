FROM php:8.1-apache

# システムパッケージのインストール
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libzip-dev \
    libicu-dev \
    default-mysql-client \
    && docker-php-ext-install pdo_mysql zip intl

# Composerのインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Apacheのrewriteモジュールを有効化
RUN a2enmod rewrite

# 作業ディレクトリの設定
WORKDIR /var/www/html

# Laravelアプリケーションのコピー
COPY . /var/www/html

# Composerのインストールと設定
RUN composer install --no-dev --optimize-autoloader

# アプリケーション設定ファイルのコピー
#COPY .env.docker /var/www/html/.env
RUN cp .env.docker /var/www/html/.env

# アプリケーションキーの生成
RUN php artisan key:generate

# Apacheの設定ファイルのコピー
COPY apache-vhost.conf /etc/apache2/sites-available/000-default.conf

# composer.jsonのコピー
#COPY composer.json /var/www/html/composer.json

# 公開ディレクトリのパーミッション設定
RUN chown -R www-data:www-data storage bootstrap/cache

# Dockerfileの最後の部分を以下のように変更
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

CMD ["/usr/local/bin/docker-entrypoint.sh"]