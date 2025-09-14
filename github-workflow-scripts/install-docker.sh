#!/bin/bash
set -e

# Install Docker if not exists
if ! command -v docker &> /dev/null; then
  echo "Installing Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  sudo usermod -aG docker $USER
  rm get-docker.sh
  echo "Docker installed successfully"
else
  echo "Docker is already installed"
fi
docker --version

# Start Docker service if not running
if ! sudo systemctl is-active docker &> /dev/null; then
  echo "Starting Docker service..."
  sudo systemctl start docker
  sudo systemctl enable docker
fi