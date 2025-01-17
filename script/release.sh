#!/usr/bin/env bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_DIR=$(dirname ${SCRIPT_DIR})

# 获取 RELEASE_DIR
source ${SCRIPT_DIR}/version.sh
cd ${PROJECT_DIR}
# 创建 RELEASE_DIR
mkdir -p ${RELEASE_DIR}
# 创建 bin/latest 软链接, 指向 RELEASE_DIR
rm -f bin/latest & ln -s $(realpath --relative-to=bin ${RELEASE_DIR}) bin/latest
cd ${RELEASE_DIR}

# 编译
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app_linux_amd64 -ldflags "${LDFLAGS}" github.com/ssst0n3/app-template/cmd/app
CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o app_linux_arm64 -ldflags "${LDFLAGS}" github.com/ssst0n3/app-template/cmd/app

# 压缩
cd -
upx bin/latest/* || echo done
