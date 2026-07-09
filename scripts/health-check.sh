#!/bin/bash

set -e

echo "Checking Portfolio App..."
curl -f http://localhost:5000

echo "Checking Flask App..."
curl -f http://localhost:5001

echo "Checking Java App..."

for i in {1..10}; do
    if curl -fs http://localhost:8081 > /dev/null; then
        echo "Java App OK"
        break
    fi

    echo "Waiting for Java App... ($i/10)"
    sleep 5
done

# Final verification
curl -fs http://localhost:8081 > /dev/null

echo "All applications are healthy."
