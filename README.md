# deno-with-docker-cli

[![Docker](https://img.shields.io/badge/denoland%2Fdeno-2.9.1-blue)](https://hub.docker.com/r/denoland/deno)
[![Docker CLI](https://img.shields.io/badge/docker%20cli-29.6.1-blue)](https://github.com/docker/cli)

A Docker image based on [`denoland/deno:2.9.1`](https://hub.docker.com/r/denoland/deno) with the
Docker CLI (`docker-ce-cli`) installed on top. It lets you run a Deno project that can control the
Docker daemon on the host by bind-mounting the Docker socket.

The image is published to the GitHub Container Registry:

```
ghcr.io/etienne-dldc/deno-with-docker-cli
```

## Available tags

| Tag                              | Description                                        |
| -------------------------------- | -------------------------------------------------- |
| `latest`                         | Tracks the latest published build.                 |
| `deno-2.9.1-dockercli-29.6.1`    | Pinned to Deno `2.9.1` and Docker CLI `29.6.1`.    |

Built for `linux/amd64` and `linux/arm64`.

## Usage

Run a Deno script while controlling Docker on the host by mounting the Docker socket:

```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD":/app \
  -w /app \
  ghcr.io/etienne-dldc/deno-with-docker-cli \
  deno run --allow-all main.ts
```

Because the socket is mounted and the container runs as `root`, `docker` commands issued from
inside the container talk to the host daemon. You can also start an interactive shell:

```bash
docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/etienne-dldc/deno-with-docker-cli sh
```

## Verification

```bash
docker run --rm ghcr.io/etienne-dldc/deno-with-docker-cli deno --version
docker run --rm ghcr.io/etienne-dldc/deno-with-docker-cli docker --version
```

## Rebuilding

The Deno and Docker CLI versions are defined as build args (`DENO_VERSION` and
`DOCKER_CLI_VERSION`) and mirrored in `.github/workflows/publish.yml`. Pushing to `main` rebuilds
the image and publishes it to GHCR with the version tag and `latest`.
