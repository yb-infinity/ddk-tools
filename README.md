# Docker Image with Development Tools

### (PHP, Composer, PHP-Parallel-Lint, composer-normalize) based on Alpine Linux

[![Docker Image CI](https://github.com/yb-infinity/ddk-tools/actions/workflows/docker.yml/badge.svg)](https://github.com/yb-infinity/ddk-tools/actions/workflows/docker.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/drakemazzy/ddk-tools.svg)](https://hub.docker.com/r/drakemazzy/ddk-tools)
[![Docker Image Size](https://img.shields.io/docker/image-size/drakemazzy/ddk-tools/latest)](https://hub.docker.com/r/drakemazzy/ddk-tools)
[![Docker Stars](https://img.shields.io/docker/stars/drakemazzy/ddk-tools.svg)](https://hub.docker.com/r/drakemazzy/ddk-tools)
[![License: GPL-2.0-or-later](https://img.shields.io/badge/License-GPL%20v2+-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0-standalone.html)

This project provides a Docker image that includes(latest):
- [PHP](https://www.php.net/) (distributed under the [PHP License](https://www.php.net/license/))
- [Composer 2.8.9](https://getcomposer.org/) (licensed under [MIT](https://github.com/composer/composer/blob/main/LICENSE))
- [composer-normalize 2.47.0](https://github.com/ergebnis/composer-normalize) (MIT)
- [PHP-Parallel-Lint 1.4.0](https://github.com/php-parallel-lint/PHP-Parallel-Lint) (BSD-2-Clause)

## Usage

### Pull the Image

```bash
docker pull drakemazzy/ddk-tools:latest
```

### Running Tools

Basic Composer usage:
```bash
docker run --rm -v $(pwd):/tmp drakemazzy/ddk-tools:latest composer validate
```

Normalize composer.json:
```bash
docker run --rm -v $(pwd):/tmp drakemazzy/ddk-tools:latest composer-normalize
```

PHP Parallel Lint:
```bash
docker run --rm -v $(pwd):/tmp drakemazzy/ddk-tools:latest parallel-lint ./src
```

### Integration Examples

#### Bitbucket Pipelines

Add this to your `bitbucket-pipelines.yml`:

```yaml
pipelines:
  default:
    - step:
        image: drakemazzy/ddk-tools:latest
        name: Code Quality
        script:
          - parallel-lint ./src
          - composer-normalize --dry-run
```

## Build Arguments

The image supports the following build arguments:

| Argument      | Description           | Default     |
| ------------- | --------------------- | ----------- |
| PHP_VER       | PHP version           | 8.1-4       |
| COMPOSER_VER  | Composer version      | 2.8.9       |
| NORMALIZE_VER | Normalize version     | 2.47.0      |
| PARALLEL_VER  | Parallel-Lint version | 1.4.0       |
| BUILD_VER     | Build version         | git SHA     |
| BUILD_DATE    | Build date            | Current UTC |

## Multi-Platform Support

The image is available for the following platforms:
- linux/amd64
- linux/arm64

## Security Features

This image includes:
- Alpine Linux base for minimal attack surface
- Tini init system
- Regular security updates

## Development

### Prerequisites

- Docker
- Docker Buildx
- GitHub Actions Runner (for CI/CD)

### Local Build

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t drakemazzy/ddk-tools:latest .
```

## License

This project is released under the GNU General Public License v2.0 or later.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any problems or have suggestions, please open an issue in the GitHub repository.
