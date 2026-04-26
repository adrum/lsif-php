# syntax=docker/dockerfile:1.7
# Multi-arch image: builds for linux/amd64 and linux/arm64.
#
# Stage 1: install composer dependencies in a builder so the runtime image
# doesn't carry composer or build-time deps.
FROM composer:2 AS builder

WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-progress --no-interaction --optimize-autoloader

# Stage 2: sourcegraph CLI for `src code-intel upload` workflows that pair
# with the LSIF dump produced by lsif-php.
FROM sourcegraph/src-cli:5 AS src-cli

# Stage 3: minimal PHP runtime with lsif-php on the PATH.
FROM php:8.4-cli-alpine

RUN apk add --no-cache git \
    && echo 'memory_limit=1G' > /usr/local/etc/php/conf.d/memory.ini

COPY --from=builder /app/vendor /app/vendor
COPY bin /app/bin
COPY src /app/src
COPY --from=src-cli /usr/bin/src /usr/bin/src

RUN ln -s /app/bin/lsif-php /usr/bin/lsif-php

WORKDIR /src

ENTRYPOINT ["lsif-php"]
CMD ["--help"]
