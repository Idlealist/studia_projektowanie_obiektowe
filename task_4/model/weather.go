package model

import "gorm.io/gorm"

type Weather struct {
	gorm.Model
	City        string
	Temperature float64
	Description string
}
