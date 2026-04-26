# lsif-php [![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/adrum/lsif-php)

[![CI](https://github.com/adrum/lsif-php/actions/workflows/ci.yml/badge.svg)](https://github.com/adrum/lsif-php/actions/workflows/ci.yml)
[![Coverage](https://codecov.io/gh/adrum/lsif-php/branch/main/graph/badge.svg?token=4NZWCF6LZS)](https://codecov.io/gh/adrum/lsif-php)
[![License: MIT](https://img.shields.io/github/license/adrum/lsif-php)](https://github.com/adrum/lsif-php/blob/main/LICENSE)
[![Packagist Version](https://img.shields.io/packagist/v/adrum/lsif-php)](https://packagist.org/packages/adrum/lsif-php)
[![PHP Version](https://img.shields.io/packagist/php-v/adrum/lsif-php)](https://packagist.org/packages/adrum/lsif-php)
[![Docker Image Version](https://img.shields.io/docker/v/adrum/lsif-php?label=docker)](https://hub.docker.com/r/adrum/lsif-php)
[![Docker Image Size](https://img.shields.io/docker/image-size/adrum/lsif-php)](https://hub.docker.com/r/adrum/lsif-php)

Language Server Indexing Format (LSIF) generator for PHP

---

This repository is indexed using itself and available on [Sourcegraph](https://sourcegraph.com/github.com/adrum/lsif-php).

## Requirements

`lsif-php` needs the `composer.json` and `composer.lock` file of
the project to index present in the current directory. It uses the
[`autoload`](https://getcomposer.org/doc/04-schema.md#autoload) and
[`autoload-dev`](https://getcomposer.org/doc/04-schema.md#autoload-dev)
properties to determine which directories to scan.

## Usage

To use a self-hosted Sourcegraph instance, set the
`SRC_ENDPOINT` and `SRC_ACCESS_TOKEN` [environment
variables](https://docs.sourcegraph.com/cli/explanations/env).

### GitHub Actions

Add the following job to your workflow:

```yml
on:
  - push

jobs:
  lsif-php:
    runs-on: ubuntu-latest
    container: adrum/lsif-php:main
    steps:
      - uses: actions/checkout@v3
      - name: Generate LSIF data
        run: lsif-php
      - name: Apply container owner mismatch workaround
        run: |
          # FIXME: see https://github.com/actions/checkout/issues/760
          git config --global --add safe.directory ${GITHUB_WORKSPACE}
      - name: Upload LSIF data
        run: src code-intel upload -github-token=${{ secrets.GITHUB_TOKEN }}
```

### [GitLab CI/CD](https://docs.gitlab.com/ee/user/project/code_intelligence.html)

Add the following job to your pipeline:

```yml
code_navigation:
  image: adrum/lsif-php:main
  artifacts:
    reports:
      lsif: dump.lsif
  script:
    - lsif-php
    - src code-intel upload
```

### Manual

Install [`lsif-php`](https://packagist.org/packages/adrum/lsif-php)
with `composer` and the
[`src`](https://docs.sourcegraph.com/cli/quickstart) binary. Then generate
the LSIF data and upload it:

```bash
$ composer require --dev adrum/lsif-php
$ vendor/bin/lsif-php
$ src code-intel upload
```

## Acknowledgements

This project is a fork of [`davidrjenni/lsif-php`](https://github.com/davidrjenni/lsif-php).
Huge thanks to [David R. Jenni](https://github.com/davidrjenni) for creating
the original tool and laying the groundwork that made this fork possible.
