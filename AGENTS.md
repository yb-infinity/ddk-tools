# Agents Guide for ddk-tools

This project maintains the `ddk-tools` Docker image, a lightweight, Alpine-based toolkit for Drupal and PHP development.

## Project Mission
To provide a consistent, multi-platform (amd64/arm64) environment for PHP code quality tools (linting, composer normalization) across various PHP versions.

## Key Components

### Software Stack
- **Base OS**: Alpine Linux (3.19.9 for PHP 8.1, 3.22.3 for PHP 8.2, 3.23.3 for PHP 8.3+).
- **PHP**: Supports versions 8.1, 8.2, 8.3, 8.4, and 8.5.
- **Composer**: Dependency manager for PHP.
- **composer-normalize**: Tool to normalize `composer.json`.
- **PHP-Parallel-Lint**: Fast linting of PHP files.

### Critical Files
- `Dockerfile`: Multi-stage build using `ARG` for versioning.
- `entrypoint.sh`: Handles environment setup, specifically supporting Bitbucket Pipelines (`BITBUCKET_CLONE_DIR`).
- `.github/workflows/docker.yml`: Complex CI/CD pipeline managing multi-arch builds and PHP version matrices.

## Build & Release Process

### CI/CD Workflow
1. **Prepare**: Generates a short SHA for tagging.
2. **Build**: Uses GitHub Actions matrix to build for each PHP version and platform (amd64, arm64).
3. **Publish**: Creates multi-arch manifests and cleans up architecture-specific tags.
4. **Security**: Runs Trivy scans on the final images.
5. **Release**: Tags images based on git tags (e.g., `v1.0.0-php84`).

### Local Development
To build a specific version locally:
```bash
docker build --build-arg PHP_VER=84 --build-arg ALPINE_VER=3.22.1 -t ddk-tools:local .
```

## Agent Responsibilities

### Maintenance
- **Version Updates**: Monitor for new releases of Composer, `composer-normalize`, and `parallel-lint`. Update the default `ARG` values in `Dockerfile` and the matrix in `docker.yml`.
- **PHP Support**: When a new PHP version is released, add it to the GitHub Actions matrix and update `Dockerfile` logic if necessary (especially Alpine package names).
- **Security**: Monitor Trivy scan results in GitHub Actions and update the base Alpine image or PHP packages to address vulnerabilities.

### Documentation
- Ensure `README.md` reflects the latest versions and supported PHP versions.
- Maintain consistency between the `Dockerfile` defaults and the CI matrix.

## Troubleshooting
- **Path Issues**: The `entrypoint.sh` defaults to `/tmp` if `BITBUCKET_CLONE_DIR` is not set. Ensure volume mounts in Docker target `/tmp` or set the working directory appropriately.
- **Immutability**: The `Dockerfile` aggressively cleans up `apk` (removes `/etc/apk` and `/lib/apk`) after building. This means the image is highly optimized for size but **cannot** have additional packages installed at runtime.
- **Multi-Arch**: If a build fails for a specific architecture, check the PHP package availability in the respective Alpine version repository.
