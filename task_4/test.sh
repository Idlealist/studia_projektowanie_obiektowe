#!/bin/bash

URL="http://localhost:8080/weather"

DATA='{"cities": ["Warsaw", "Paris", "Zurich"]}'

echo "POST /weather $DATA"
RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" -d "$DATA" "$URL")

echo "RESPONSE:"
echo "$RESPONSE" | jq .
