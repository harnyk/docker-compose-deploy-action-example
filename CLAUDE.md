# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker Compose deployment automation example that provides both GitHub Actions workflow for CI/CD and AWS EC2 instance management scripts. The project demonstrates automated deployment of containerized applications using Docker Compose with minimal downtime.

## Architecture

### Core Components
- **docker-compose.yaml**: Defines a single nginx web service with resource limits, security hardening, and health checks
- **GitHub Actions Workflow** (`.github/workflows/deploy.yml`): Automated deployment pipeline that copies files, installs Docker, and deploys via SSH
- **AWS Management Scripts** (`aws-scripts/`): Local EC2 instance lifecycle management using aws-vault
- **Deployment Scripts** (`github-workflow-scripts/`): Server-side scripts for Docker installation and deployment

### Deployment Flow
1. GitHub Actions copies repository files to remote server via SCP
2. Installs/updates Docker and Docker Compose on target server
3. Validates docker-compose.yaml configuration
4. Deploys with `--pull always --force-recreate` for minimal downtime
5. Verifies deployment success

## Common Commands

### AWS Instance Management (Local)
```bash
# Start EC2 instance and update GitHub variables
./aws-scripts/start.sh

# Stop EC2 instance
./aws-scripts/stop.sh

# Check instance status
./aws-scripts/check.sh

# SSH to instance
./aws-scripts/ssh-connect.sh
```

### Manual Deployment (Remote Server)
```bash
# Test docker-compose configuration
docker compose -f docker-compose.yaml config

# Deploy with latest images
docker compose -f docker-compose.yaml up -d --pull always --force-recreate

# Check service status
docker compose -f docker-compose.yaml ps

# View logs
docker compose -f docker-compose.yaml logs
```

### GitHub Actions Deployment
```bash
# Trigger deployment from CLI
gh workflow run deploy.yml

# Check workflow status
gh run list
```

## Configuration Requirements

### Environment Variables (.env file)
- `INSTANCE_NAME`: AWS EC2 instance name tag
- `SSH_KEY_FILE`: Path to SSH private key
- `SSH_USERNAME`: SSH username for server access

### GitHub Repository Settings
**Variables:**
- `SSH_HOST`: Server IP/domain (auto-updated by start.sh)
- `SSH_USERNAME`: SSH username
- `SSH_PORT`: SSH port (usually 22)
- `TARGET_DIR`: Deployment directory path

**Secrets:**
- `SSH_PRIVATE_KEY`: SSH private key content (auto-updated by start.sh)
- `SSH_PASSPHRASE`: SSH key passphrase (optional)

## Important Notes

### AWS CLI Usage
- Uses `aws-vault exec admin -- aws` pattern for credential management
- All aws-scripts assume us-east-1 region
- Instance public IP changes on each start/stop cycle

### Security Features
- Docker containers run with security hardening (no-new-privileges, tmpfs mounts)
- Resource limits prevent resource exhaustion
- Health checks ensure service availability
- SSH key-based authentication only

### Deployment Strategy
- Zero-config: scripts automatically detect and install Docker/Docker Compose
- Minimal downtime: uses `--force-recreate` with health checks
- Always pulls latest images to ensure updates
- Automatic rollback on deployment failure