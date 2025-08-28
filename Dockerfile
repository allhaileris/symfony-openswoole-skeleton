# build
FROM php:8.2-fpm-alpine AS builder
ARG APP_ENV=${APP_ENV}

RUN apk add --no-cache --update php82 git
WORKDIR /opt/app
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
COPY . .
RUN if [ "$APP_ENV" == "dev" ]; \
    then \
        composer install --ignore-platform-reqs; \
    else \
        composer install --ignore-platform-reqs --no-dev --optimize-autoloader; \
    fi

# final
FROM openswoole/swoole:25.2-php8.2 AS runner
ARG APP_ENV=${APP_ENV}

WORKDIR /opt/app
COPY --from=builder /opt/app/ .
COPY swoole.conf /etc/supervisor/service.d/swoole.conf

EXPOSE 9501

ENTRYPOINT ["/tini", "-g", "--", "/entrypoint.sh"]
