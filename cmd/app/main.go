package main

import (
	"fmt"
	"github.com/ssst0n3/app-template/config"
	"github.com/ssst0n3/app-template/database"
	"github.com/ssst0n3/app-template/router"
	"github.com/ssst0n3/awesome_libs/awesome_error"
)

// @securityDefinitions.apikey ApiKeyAuth
// @in header
// @name token
func main() {
	database.Init()
	r := router.InitRouter()
	awesome_error.CheckFatal(r.Run(fmt.Sprintf(":%s", config.LocalListenPort)))
}
