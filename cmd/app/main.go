package main

import (
	"fmt"
	"github.com/ssst0n3/app-template/config"
	"github.com/ssst0n3/app-template/database"
	"github.com/ssst0n3/app-template/router"
	"github.com/ssst0n3/awesome_libs/awesome_error"
	"github.com/ctrsploit/sploit-spec/pkg/version"
	"github.com/urfave/cli/v2"
	"os"
)

// @securityDefinitions.apikey ApiKeyAuth
// @in header
// @name token
func main() {
	app := &cli.App{
		Name: "app",
		Usage: "",
		Commands: []*cli.Command{
			version.Command,
		},
		Action: func(c *cli.Context) (err error) {
			database.Init()
			r := router.InitRouter()
			err = r.Run(fmt.Sprintf(":%s", config.LocalListenPort))
			return
		},
	}
	awesome_error.CheckFatal(app.Run(os.Args))
}
