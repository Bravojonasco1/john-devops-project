#!/bin/bash

set -e

echo "Checking Portfolio..."

curl -f http://localhost:5000 >/dev/null

echo "Portfolio OK"

echo "Checking Flask..."

curl -f http://localhost:5001 >/dev/null

echo "Flask OK"

echo "Checking Java..."

curl -f http://localhost:8080 >/dev/null

echo "Java OK"

echo "All applications are healthy."
