# app template project

## build
```
docker pull docker/dockerfile:1.2
COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose build
```

## dev environment

### build binary

```
make binary CN=1
```

### get a dev image

```
make shell CN=1
```