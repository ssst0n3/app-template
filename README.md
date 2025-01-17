# app template project

## build

### build the container
```
docker pull docker/dockerfile:1.2
COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose build
```

## dev environment

### build binary

build in the host

```
make build
```

build in the container

```
make binary CN=1
```

### get a dev image

```
make shell CN=1
```