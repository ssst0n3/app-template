package config

import (
	"github.com/sirupsen/logrus"
	"github.com/ssst0n3/awesome_libs/log"
	"github.com/ssst0n3/lightweight_api"
	"os"
	"strings"
)

const (
	EnvLocalListenPort = "LOCAL_LISTEN_PORT"
	EnvSwaggerHost     = "SWAGGER_HOST"
	EnvAllowOrigins    = "ALLOW_ORIGINS"
	EnvDebug           = "DEBUG"
)

var (
	LocalListenPort = os.Getenv(EnvLocalListenPort)
	SwaggerHost     = os.Getenv(EnvSwaggerHost)
	AllowOrigins    []string
	Debug           = os.Getenv(EnvDebug) == "true"
)

func init() {
	origins := os.Getenv(EnvAllowOrigins)
	if len(strings.TrimSpace(origins)) == 0 {
		AllowOrigins = nil
	} else {
		AllowOrigins = strings.Split(origins, ",")
	}
	if Debug {
		debug()
	}
}

func debug() {
	log.Logger.Level = logrus.DebugLevel
	lightweight_api.Logger.Level = logrus.DebugLevel
	log.Logger.Debug("debug mode enabled")
}
