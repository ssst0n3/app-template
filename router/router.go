package router

import (
	"fmt"
	"github.com/gin-contrib/cors"
	"github.com/gin-contrib/static"
	"github.com/gin-gonic/gin"
	v1 "github.com/ssst0n3/app-template/api/v1"
	"github.com/ssst0n3/app-template/config"
	"github.com/ssst0n3/app-template/docs"
	"github.com/ssst0n3/lightweight_api/example/resource/auth"
	"github.com/ssst0n3/lightweight_api/example/resource/user"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
	"net/http"
)

type ResponsePing struct {
	Message string `json:"message" example:"pong"`
}

// Ping godoc
// @Summary ping pong
// @Description return pong
// @ID ping-pong
// @Accept  json
// @Produce  json
// @Success 200 {object} ResponsePing
// @Router /ping [get]
func Ping(c *gin.Context) {
	c.JSON(http.StatusOK, ResponsePing{Message: "pong"})
}

func InitRouter() *gin.Engine {
	router := gin.Default()
	// cors
	if config.AllowOrigins != nil {
		corsConfig := cors.DefaultConfig()
		//corsConfig.AllowAllOrigins = true
		corsConfig.AllowCredentials = true
		corsConfig.AllowOrigins = append(corsConfig.AllowOrigins, config.AllowOrigins...)
		router.Use(cors.New(corsConfig))
	}
	//frontend
	{
		router.Use(static.Serve("/", static.LocalFile("./html", false)))
	}
	// ping pong
	{
		router.GET("/ping", Ping)
	}
	// swagger
	{
		// programmatically set swagger info
		docs.SwaggerInfo.Title = "app-template API"
		docs.SwaggerInfo.Description = "app-template"
		docs.SwaggerInfo.Version = "1.0"
		docs.SwaggerInfo.Host = fmt.Sprintf("%s:%s", config.SwaggerHost, config.LocalListenPort)
		docs.SwaggerInfo.BasePath = "/"
		docs.SwaggerInfo.Schemes = []string{"http"}
		router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	}
	// auth
	{
		auth.InitRouter(router)
		user.InitRouter(router)
	}
	{
		v1.InitRouter(router)
	}
	return router
}
