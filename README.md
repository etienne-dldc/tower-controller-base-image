# tower-controller-base-image

[![Docker](https://img.shields.io/badge/denoland%2Fdeno-2.9.1-blue)](https://hub.docker.com/r/denoland/deno)
[![Docker CLI](https://img.shields.io/badge/docker%20cli-29.6.1-blue)](https://github.com/docker/cli)
[![Git](https://img.shields.io/badge/git-included-blue)](https://git-scm.com/)

A custom Docker image bundling the dependencies needed by one of my projects. It is built on top of
[`denoland/deno`](https://hub.docker.com/r/denoland/deno) and adds the Docker CLI and Git on top,
so a container based on this image can drive the host Docker daemon (via the mounted Docker socket)
and interact with Git repositories.

The image is published to the GitHub Container Registry:

```
ghcr.io/etienne-dldc/tower-controller-base-image
```

## What's included

- **Deno** runtime (`denoland/deno` base image)
- **Docker CLI** (`docker-ce-cli`) so `docker` commands issued from inside the container talk to the
  host daemon when `/var/run/docker.sock` is bind-mounted
- **Git** for repository interaction
- **zstd** for compression (used by the backup system)

## Available tags

| Tag       | Description                                       |
| --------- | ------------------------------------------------- |
| `latest`  | Tracks the most recently published build.         |
| `<VERSION>` | Pinned to a specific image version (e.g. `1.0.0`). |

Built for `linux/amd64` and `linux/arm64`.

## Usage

Run a Deno script while controlling Docker on the host by mounting the Docker socket:

```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD":/app \
  -w /app \
  ghcr.io/etienne-dldc/tower-controller-base-image \
  deno run --allow-all main.ts
```

Because the socket is mounted and the container runs as `root`, `docker` commands issued from
inside the container talk to the host daemon. You can also start an interactive shell:

```bash
docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/etienne-dldc/tower-controller-base-image sh
```

## Verification

```bash
docker run --rm ghcr.io/etienne-dldc/tower-controller-base-image deno --version
docker run --rm ghcr.io/etienne-dldc/tower-controller-base-image docker --version
docker run --rm ghcr.io/etienne-dldc/tower-controller-base-image git --version
```

## Publishing

The image version is driven by a single `VERSION` environment variable in
`.github/workflows/publish.yml`. Pushing to `main` (or manually dispatching the workflow) checks
whether `ghcr.io/etienne-dldc/tower-controller-base-image:<VERSION>` already exists in the
registry:

- if it **already exists**, the build/push is skipped (no-op),
- if it **does not exist**, the image is built and pushed with both the `<VERSION>` tag and `latest`.

To publish a new version, bump `VERSION` in `.github/workflows/publish.yml` and push to `main`. The
underlying Deno and Docker CLI versions are pinned as `ARG` defaults in the `Dockerfile`.
