package main

import (
    "net/http"
    "encoding/json"
    "log"
)

type Product struct {
    ID    int     `json:"id"`
    Name  string  `json:"name"`
    Price float64 `json:"price"`
}

var products = []Product{
    {ID: 1, Name: "Laptop", Price: 4999.99},
    {ID: 2, Name: "TV", Price: 2999.99},
    {ID: 3, Name: "Smartwatch", Price: 699.99},
}

func main() {
    http.HandleFunc("/products", handleProducts)
    http.HandleFunc("/checkout", handleCheckout)

    http.ListenAndServe(":8080", nil)
}

func handleProducts(w http.ResponseWriter, r *http.Request) {
    setupCORS(&w, r)
    if r.Method == http.MethodOptions {
        return
    }
    json.NewEncoder(w).Encode(products)
}

func handleCheckout(w http.ResponseWriter, r *http.Request) {
    setupCORS(&w, r)
    if r.Method == http.MethodOptions {
        return
    }
    var order []Product
    json.NewDecoder(r.Body).Decode(&order)
    log.Println("Order:", order)
    w.WriteHeader(http.StatusOK)
}

func setupCORS(w *http.ResponseWriter, r *http.Request) {
    (*w).Header().Set("Access-Control-Allow-Origin", "*")
    (*w).Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
    (*w).Header().Set("Access-Control-Allow-Headers", "Content-Type")
}
