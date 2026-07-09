#!/bin/bash

set -e

echo "========================================="
echo "Pulling latest Docker images..."
echo "========================================="

docker compose pull

echo "========================================="
echo "Stopping existing containers..."
echo "========================================="

docker compose down || true

echo "========================================="
echo "Starting containers..."
echo "========================================="

docker compose up -d

echo "========================================="
echo "Deployment Complete"
echo "========================================="
