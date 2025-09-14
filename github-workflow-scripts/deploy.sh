#!/bin/bash
set -e

# Validate COMPOSE_FILE environment variable is provided
if [ -z "$COMPOSE_FILE" ]; then
  echo "ERROR: COMPOSE_FILE environment variable is required!"
  echo "Example: COMPOSE_FILE=docker-compose.yaml"
  exit 1
fi

# Ensure TARGET_DIR is provided
if [ -z "$TARGET_DIR" ]; then
  echo "ERROR: TARGET_DIR environment variable is required!"
  exit 1
fi

cd "$TARGET_DIR"

# Verify compose file exists
if [ ! -f "$COMPOSE_FILE" ]; then
  echo "ERROR: Compose file '$COMPOSE_FILE' not found in $TARGET_DIR!"
  echo "Available files:"
  ls -la ./*.yaml ./*.yml 2>/dev/null || echo "No YAML files found"
  exit 1
fi

echo "Using compose file: $COMPOSE_FILE"

# Read Docker Compose command from setup step
if [[ -f ~/.compose_cmd ]]; then
  COMPOSE_CMD=$(cat ~/.compose_cmd)
  echo "Using saved Docker Compose command: $COMPOSE_CMD"
else
  echo "ERROR: Docker Compose not configured! Setup step failed."
  exit 1
fi

# Validate docker-compose configuration
echo "Validating Docker Compose configuration..."
if ! $COMPOSE_CMD -f "$COMPOSE_FILE" config --quiet; then
  echo "ERROR: Invalid docker-compose configuration!"
  exit 1
fi
echo "Configuration validation passed"

# Deploy with minimal downtime (pull latest images and recreate containers)
echo "Deploying services..."
if ! $COMPOSE_CMD -f "$COMPOSE_FILE" up -d --pull always --force-recreate --timeout 30; then
  echo "ERROR: Docker Compose up failed!"
  $COMPOSE_CMD -f "$COMPOSE_FILE" logs --tail=50
  exit 1
fi

# Quick verification
echo "Verifying deployment..."
sleep 5
if ! $COMPOSE_CMD -f "$COMPOSE_FILE" ps --quiet; then
  echo "ERROR: Some services failed to start!"
  $COMPOSE_CMD -f "$COMPOSE_FILE" ps
  $COMPOSE_CMD -f "$COMPOSE_FILE" logs --tail=30
  exit 1
fi

echo "Deployment completed successfully!"