#!/bin/sh
set -ex
GO111MODULE="on" GOPROXY=$GOPROXY go install github.com/swaggo/swag/cmd/swag@latest
cd $(dirname $(dirname $(readlink -f $0)))
cd cmd/app
swag init --parseDependency --parseInternal -o ../../docs