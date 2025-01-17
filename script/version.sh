#!/usr/bin/env bash

function get_version() {
    # 检查是否有任何tag
    if git describe --tags --abbrev=0 >/dev/null 2>&1; then
        # 获取最近的tag
        local LATEST_TAG=$(git describe --tags --abbrev=0)
    else
        # 没有tag，设置默认版本号
        local LATEST_TAG="init"
    fi

    # 获取最近的tag后的commit数
    if [ "$LATEST_TAG" == "init" ]; then
        local COMMITS_SINCE_TAG=$(git rev-list HEAD --count)
    else
        local COMMITS_SINCE_TAG=$(git rev-list ${LATEST_TAG}..HEAD --count)
    fi

    if [ "$COMMITS_SINCE_TAG" -eq "0" ]; then
        # 没有新的commit在最新的tag之后
        VERSION=$LATEST_TAG
        RELEASE_DIR="bin/release/${VERSION}"
    else
        # 有新的commit在最新的tag之后
        local COMMIT=$(git rev-parse --short HEAD)
        VERSION="${LATEST_TAG}-${COMMIT}"
        RELEASE_DIR="bin/dev/${VERSION}"
    fi

    # 检查是否有未暂存的修改或已暂存未提交的修改
    if ! git diff --quiet || ! git diff --cached --quiet || git ls-files --others --exclude-standard | grep -q .; then
        VERSION="${VERSION}-dirty"
        RELEASE_DIR="bin/dev/${VERSION}"
    fi
}

get_version
echo "$VERSION"
