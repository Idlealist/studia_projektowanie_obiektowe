curl -s -X POST http://localhost:8080/api/eager/users \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "password"}'
echo ""

curl -s -X POST http://localhost:8080/api/lazy/users \
  -H "Content-Type: application/json" \
  -d '{"username": "lazy", "password": "password"}'
echo ""

curl -s -X POST http://localhost:8080/api/lazy/users \
  -H "Content-Type: application/json" \
  -d '{"username": "wrong", "password": "wrong"}'
echo ""
