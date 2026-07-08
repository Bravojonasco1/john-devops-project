#!/bin/bash

echo "Cleaning Docker resources..."

docker image prune -f

docker container prune -f

docker system df
