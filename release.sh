#!/bin/bash
set -ex
# go get github.com/mitchellh/gox
cd "$(dirname "$(readlink -m "$0")")"
rm -rf bin/release/*
mkdir -p bin/release
cd bin/release
CGO_ENABLED=0 gox -cgo=0 -osarch="linux/amd64" -ldflags "${LDFLAGS}" github.com/ssst0n3/app-template/cmd/app
cd -
upx bin/release/*