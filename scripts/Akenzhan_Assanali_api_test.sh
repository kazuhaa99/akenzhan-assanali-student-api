#!/bin/bash
# API tests for Akenzhan Assanali Student API (curl).
# Usage: ./Akenzhan_Assanali_api_test.sh [base_url]
BASE_URL="${1:-http://localhost:8080}"
API="$BASE_URL/api/students"
J='Content-Type: application/json'
RUN_ID=$(date +%s)

extract_id() {
    sed -E 's/.*"id":([0-9]+).*/\1/'
}

echo "=== 1. Create a student (POST) ==="
CREATED=$(curl -s -w '\nHTTP %{http_code}' -X POST "$API" -H "$J" \
  -d "{\"firstName\":\"Assanali\",\"lastName\":\"Akenzhan\",\"email\":\"assanali.akenzhan.$RUN_ID@iitu.edu.kz\",\"course\":\"DevOps Mastery\"}")
echo "$CREATED"
ID=$(echo "$CREATED" | head -1 | extract_id)

TEMP_ID=$(curl -s -X POST "$API" -H "$J" \
  -d "{\"firstName\":\"Temp\",\"lastName\":\"Akenzhan-Test\",\"email\":\"temp.$RUN_ID@iitu.edu.kz\",\"course\":\"Docker\"}" | extract_id)

echo; echo "=== 2. Get all students (GET) ==="
curl -s -w '\nHTTP %{http_code}\n' "$API"

echo; echo "=== 3. Get student by id=$ID (GET) ==="
curl -s -w '\nHTTP %{http_code}\n' "$API/$ID"

echo; echo "=== 4. Update student id=$ID (PUT) ==="
curl -s -w '\nHTTP %{http_code}\n' -X PUT "$API/$ID" -H "$J" \
  -d "{\"firstName\":\"Assanali\",\"lastName\":\"Akenzhan\",\"email\":\"a.akenzhan.$RUN_ID@iitu.edu.kz\",\"course\":\"Jenkins CI/CD\"}"

echo; echo "=== 5. Delete the temporary student id=$TEMP_ID (DELETE) ==="
curl -s -w 'HTTP %{http_code}\n' -X DELETE "$API/$TEMP_ID"

echo; echo "=== 6. Request a nonexistent student (GET id=99999) ==="
curl -s -w '\nHTTP %{http_code}\n' "$API/99999"

echo; echo "=== Final list ==="
curl -s -w '\nHTTP %{http_code}\n' "$API"
