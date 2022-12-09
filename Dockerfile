# syntax=docker/dockerfile:1.2
FROM golang:1.19-alpine AS builder-env
ENV GO111MODULE="on"
ENV GOPROXY="https://goproxy.cn,direct"

# RUN sed -i "s@https://dl-cdn.alpinelinux.org/@https://mirrors.huaweicloud.com/@g" /etc/apk/repositories
RUN apk update && apk add upx

FROM builder-env AS builder
ENV APPNAME="app-template"
ENV CMDNAME="app"

COPY . /build
WORKDIR /build
RUN --mount=type=cache,target=/go/pkg/mod go mod tidy
# RUN ./hack/swaggo.sh
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" github.com/ssst0n3/$APPNAME/cmd/$CMDNAME
RUN upx $CMDNAME

FROM alpine
ENV CMDNAME="app"
ENV WAIT_VERSION 2.7.3
# ENV WAIT_RELEASE https://github.com/ufoscout/docker-compose-wait/releases/download/$WAIT_VERSION/wait
ENV WAIT_RELEASE https://st0n3-dev.obs.cn-south-1.myhuaweicloud.com/docker-compose-wait/release/$WAIT_VERSION/wait

ADD $WAIT_RELEASE /wait
RUN chmod +x /wait

RUN mkdir -p /app
COPY --from=builder /build/$CMDNAME /app/
#COPY --from=frontend:v0.1 /usr/share/nginx/html /app/html

WORKDIR /app
CMD /wait && ./$CMDNAME