package main

import (
	"task_4/model"
	"task_4/controller"

	"github.com/labstack/echo/v4"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"

	"github.com/joho/godotenv"
)

func main() {
	db, err := gorm.Open(sqlite.Open("data.db"), &gorm.Config{})
	if err != nil {
        panic("failed to connect to database")
    }
	db.AutoMigrate(&model.Weather{})

	godotenv.Load()

	e := echo.New()
	e.POST("/weather", controller.GetWeather(db))

	e.Logger.Fatal(e.Start(":8080"))
}
