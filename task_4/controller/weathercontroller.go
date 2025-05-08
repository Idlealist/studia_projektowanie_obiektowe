package controller

import (
	"net/http"
	"task_4/model"
	"task_4/proxy"

	"github.com/labstack/echo/v4"
	"gorm.io/gorm"
)

type Request struct {
	Cities []string `json:"cities"`
}

func GetWeather(db *gorm.DB) echo.HandlerFunc {
	return func(c echo.Context) error {
		req := new(Request)
		if err := c.Bind(req); err != nil || len(req.Cities) == 0 {
			return c.JSON(http.StatusBadRequest, echo.Map{"error": "Cities are required"})
		}
		

		var results []model.Weather

		for _, city := range req.Cities {
			temp, desc, err := proxy.FetchWeather(city)
			if err != nil {
				continue
			}
			entry := model.Weather{
				City:        city,
				Temperature: temp,
				Description: desc,
			}
			db.Create(&entry)
			results = append(results, entry)
		}

		return c.JSON(http.StatusOK, results)
	}
}
