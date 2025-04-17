#!/bin/bash

URL="http://localhost:8000"

echo "Product"

echo "POST /api/product"
PRODUCT_RESPONSE=$(curl -s -X POST "$URL/api/product" \
     -H "Content-Type: application/json" \
     -d '{"name":"Sample Product","price":19.99,"description":"A sample product"}')
PRODUCT_ID=$(echo "$PRODUCT_RESPONSE" | jq -r '.id')

echo -e "\nGET /api/product"
curl -X GET "$URL/api/product"
echo ""

echo -e "\nGET /api/product/$PRODUCT_ID"
curl -X GET "$URL/api/product/$PRODUCT_ID"
echo ""

echo -e "\nPUT /api/product/$PRODUCT_ID"
curl -X PUT "$URL/api/product/$PRODUCT_ID" \
     -H "Content-Type: application/json" \
     -d '{"name":"Updated Product","price":29.99,"description":"Updated description"}'

echo -e "\nDELETE /api/product/$PRODUCT_ID"
curl -X DELETE "$URL/api/product/$PRODUCT_ID"
echo ""

echo -e "CATEGORY"

echo "POST /api/category"
CATEGORY_RESPONSE=$(curl -s -X POST "$URL/api/category" \
     -H "Content-Type: application/json" \
     -d '{"name":"Electronics"}')
CATEGORY_ID=$(echo "$CATEGORY_RESPONSE" | jq -r '.id')

echo -e "\nGET /api/category"
curl -X GET "$URL/api/category"
echo ""

echo -e "\nGET /api/category/$CATEGORY_ID"
curl -X GET "$URL/api/category/$CATEGORY_ID"
echo ""

echo -e "\nPUT /api/category/$CATEGORY_ID"
curl -X PUT "$URL/api/category/$CATEGORY_ID" \
     -H "Content-Type: application/json" \
     -d '{"name":"Updated Electronics"}'
echo ""

echo -e "\nDELETE /api/category/$CATEGORY_ID"
curl -X DELETE "$URL/api/category/$CATEGORY_ID"
echo ""

echo -e "SUPPLIER"

echo "POST /api/supplier"
SUPPLIER_RESPONSE=$(curl -s -X POST "$URL/api/supplier" \
     -H "Content-Type: application/json" \
     -d '{"name":"Sample Supplier","email":"supplier@example.com"}')
SUPPLIER_ID=$(echo "$SUPPLIER_RESPONSE" | jq -r '.id')

echo -e "\nGET /api/supplier"
curl -X GET "$URL/api/supplier"
echo ""

echo -e "\nGET /api/supplier/$SUPPLIER_ID"
curl -X GET "$URL/api/supplier/$SUPPLIER_ID"
echo ""

echo -e "\nPUT /api/supplier/$SUPPLIER_ID"
curl -X PUT "$URL/api/supplier/$SUPPLIER_ID" \
     -H "Content-Type: application/json" \
     -d '{"name":"Updated Supplier","email":"updated.supplier@example.com"}'
echo ""

echo -e "\nDELETE /api/supplier/$SUPPLIER_ID"
curl -X DELETE "$URL/api/supplier/$SUPPLIER_ID"
echo ""

echo ""