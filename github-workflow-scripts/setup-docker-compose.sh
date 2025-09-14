#!/bin/bash
set -e

# Detect which Docker Compose command to use and save for deployment
if docker compose version &> /dev/null; then
  echo "docker compose" > ~/.compose_cmd
  echo "Using modern docker compose"
  docker compose version
elif command -v docker-compose &> /dev/null; then
  echo "docker-compose" > ~/.compose_cmd
  echo "Using legacy docker-compose"
  docker-compose --version
else
  echo "Installing docker-compose..."
  # Use specific version for security
  COMPOSE_VERSION="v2.24.0"
  COMPOSE_ARCH=$(uname -m)
  COMPOSE_OS=$(uname -s)

  # Download docker-compose binary
  sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-${COMPOSE_OS}-${COMPOSE_ARCH}" -o /usr/local/bin/docker-compose

  # Set executable permissions
  sudo chmod 755 /usr/local/bin/docker-compose
  echo "docker-compose" > ~/.compose_cmd
  docker-compose --version
fi