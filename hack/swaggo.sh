#!/bin/sh
set -ex
GO111MODULE="on" GOPROXY=$GOPROXY go install github.com/swaggo/swag/cmd/swag@v1.8.7
cd $(dirname $(dirname $(readlink -f $0)))
cd cmd/app
swag init --parseDependency --parseInternal -o ../../docs