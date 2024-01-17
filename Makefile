.PHONY: all shell local build

APP_NAME := app

# mirror
DEFAULT_CN_APT_MIRROR := "mirrors.tuna.tsinghua.edu.cn"
DEFAULT_CN_GOPROXY := "https://goproxy.cn,https://goproxy.io,direct"
APT_MIRROR ?= $(if $(CN),$(DEFAULT_CN_APT_MIRROR),)
GOPROXY ?= $(if $(CN),$(DEFAULT_CN_GOPROXY),)

PROGRESS_PLAIN := --progress plain
DEBUG_FLGAS ?= $(if $(DEBUG),$(PROGRESS_PLAIN),)

GITCOMMIT := $(shell git rev-parse --short HEAD || echo unsupported)
VERSION := $(shell cat ./VERSION)
BUILDTIME := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
LDFLAGS := "${LDFALGS} \
	-X github.com/ctrsploit/sploit-spec/pkg/version.Version=${VERSION} \
	-X github.com/ctrsploit/sploit-spec/pkg/version.GitCommit=${GITCOMMIT} \
	-X github.com/ctrsploit/sploit-spec/pkg/version.BuildTime=${BUILDTIME}"

DOCKER_CONTAINER_NAME := $(if $(CONTAINER_NAME),--name $(CONTAINER_NAME),)
DEV_IMAGE := ${APP_NAME}-dev
DOCKER_FLAGS := docker run --rm -ti $(DOCKER_CONTAINER_NAME) $(DOCKER_ENVS) $(DOCKER_MOUNT)

DOCKER_RUN_DOCKER := $(DOCKER_FLAGS) "$(DEV_IMAGE)"
DOCKERFILE := Dockerfile_dev

BUILD_APT_MIRROR := $(if $(APT_MIRROR),--build-arg APT_MIRROR=$(APT_MIRROR))
BUILD_GO_PROXY := $(if $(GOPROXY),--build-arg GOPROXY=$(GOPROXY))
BUILD_OPTS := ${BUILD_APT_MIRROR} ${BUILD_GO_PROXY} ${DOCKER_BUILD_ARGS} ${DOCKER_BUILD_OPTS} -f "$(DOCKERFILE)"

binary: bundle
	APT_MIRROR=$(APT_MIRROR) GOPROXY=$(GOPROXY) docker buildx bake binary ${DEBUG_FLGAS}

bundle:
	mkdir -p bin/release

build:
	LDFLAGS=${LDFLAGS} ./release.sh

install: build
	ln -s $(CURDIR)/bin/release/${APP_NAME}_linux_amd64 /usr/local/bin/${APP_NAME}

image: bundle
	docker buildx build $(BUILD_OPTS) --load -t "$(DEV_IMAGE)" ${DEBUG_FLGAS} .

shell: image
	docker run --rm -ti -v $(CURDIR):/root/app $(DEV_IMAGE) bash

# usage:
# make binary CN=1 DEBUG=1
# make shell CN=1 DEBUG=1
# make install
