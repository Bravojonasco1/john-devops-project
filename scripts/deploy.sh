#!/bin/bash

set -e

echo "========================================="
echo "Stopping existing containers..."
echo "========================================="

docker compose down || true

echo "========================================="
echo "Starting updated containers..."
echo "========================================="

docker compose up -d

echo "========================================="
echo "Deployment Complete"
echo "========================================="
