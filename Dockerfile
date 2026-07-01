# syntax=docker/dockerfile:1

ARG DENO_VERSION=2.9.1
ARG DOCKER_CLI_VERSION=29.6.1

FROM denoland/deno:${DENO_VERSION}

ARG DOCKER_CLI_VERSION

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl; \
    install -m 0755 -d /etc/apt/keyrings; \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc; \
    chmod a+r /etc/apt/keyrings/docker.asc; \
    . /etc/os-release; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${VERSION_CODENAME} stable" > /etc/apt/sources.list.d/docker.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends "docker-ce-cli=5:${DOCKER_CLI_VERSION}*"; \
    rm -rf /var/lib/apt/lists/*
