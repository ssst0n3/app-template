package config

import (
	"os"
	"strings"
)

const (
	EnvLocalListenPort = "LOCAL_LISTEN_PORT"
	EnvSwaggerHost     = "SWAGGER_HOST"
	EnvAllowOrigins    = "ALLOW_ORIGINS"
)

var (
	LocalListenPort = os.Getenv(EnvLocalListenPort)
	SwaggerHost     = os.Getenv(EnvSwaggerHost)
	AllowOrigins    []string
)

func init() {
	origins := os.Getenv(EnvAllowOrigins)
	if len(strings.TrimSpace(origins)) == 0 {
		AllowOrigins = nil
	} else {
		AllowOrigins = strings.Split(origins, ",")
	}
}
