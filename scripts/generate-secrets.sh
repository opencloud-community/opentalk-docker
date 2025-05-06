#!/bin/bash
#
# Script to generate secure secrets for OpenTalk configuration
# 
# Usage: ./generate-secrets.sh [length]
#        length - Optional password length (default: 32)
#

set -e

# Set default password length if not provided
LENGTH=${1:-32}

# Check if we have the required tools
if command -v openssl &>/dev/null; then
    GEN_CMD="openssl rand -base64 $((LENGTH * 3/4)) | tr -d '/+=\n' | cut -c1-$LENGTH"
elif command -v pwgen &>/dev/null; then
    GEN_CMD="pwgen -s $LENGTH 1"
else
    echo "Error: Neither openssl nor pwgen found. Please install one of them."
    exit 1
fi

# Function to generate a secure random password
generate_password() {
    eval "$GEN_CMD"
}

# Generate secrets
DB_PASSWORD=$(generate_password)
KEYCLOAK_ADMIN_PASSWORD=$(generate_password)
KEYCLOAK_CLIENT_SECRET_CONTROLLER=$(generate_password)
KEYCLOAK_CLIENT_SECRET_OBELISK=$(generate_password)
KEYCLOAK_CLIENT_SECRET_RECORDER=$(generate_password)
LIVEKIT_API_KEY=$(generate_password)
LIVEKIT_API_SECRET=$(generate_password)
MINIO_ROOT_PASSWORD=$(generate_password)
RABBITMQ_PASSWORD=$(generate_password)

# Output generated secrets in .env format
cat << EOF
# Generated secrets for OpenTalk deployment
# Generated on $(date)
# Add these to your .env file

# Database
POSTGRES_PASSWORD=$DB_PASSWORD

# Keycloak
KEYCLOAK_ADMIN_PASSWORD=$KEYCLOAK_ADMIN_PASSWORD
KEYCLOAK_CLIENT_SECRET_CONTROLLER=$KEYCLOAK_CLIENT_SECRET_CONTROLLER
KEYCLOAK_CLIENT_SECRET_OBELISK=$KEYCLOAK_CLIENT_SECRET_OBELISK
KEYCLOAK_CLIENT_SECRET_RECORDER=$KEYCLOAK_CLIENT_SECRET_RECORDER

# LiveKit
LIVEKIT_API_KEY=$LIVEKIT_API_KEY
LIVEKIT_API_SECRET=$LIVEKIT_API_SECRET

# MinIO
MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD

# RabbitMQ
RABBITMQ_PASSWORD=$RABBITMQ_PASSWORD

# -------------------------------------------------------------------
# Instructions:
# 1. Copy these values to your .env file
# 2. Update controller.toml with these values where applicable:
#    - Database password: $DB_PASSWORD
#    - Controller client secret: $KEYCLOAK_CLIENT_SECRET_CONTROLLER
#    - LiveKit API key: $LIVEKIT_API_KEY
#    - LiveKit API secret: $LIVEKIT_API_SECRET
# -------------------------------------------------------------------
EOF