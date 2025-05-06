# Getting Started with OpenTalk Docker

This section covers how to get started with OpenTalk using Docker and Docker Compose.

> **Note**: For official OpenTalk installation guides, please refer to the [official OpenTalk documentation](https://docs.opentalk.eu/admin/).

## Overview

OpenTalk is a comprehensive video conferencing solution that consists of several components:

1. **OpenTalk Controller** - The core component that handles the API and signaling
2. **OpenTalk Frontend** - The web client that users interact with
3. **Supporting Services:**
   - Keycloak - Authentication and user management
   - LiveKit - WebRTC media server
   - PostgreSQL - Database
   - MinIO - Object storage
   - Redis - (Optional) For multi-node clusters
   - RabbitMQ - (Optional) For messaging between services

4. **Optional Components:**
   - OpenTalk Obelisk - Telephone dial-in functionality
   - OpenTalk Recorder - Recording functionality
   - OpenTalk SMTP Mailer - Email notifications

## Quick Links

- [Prerequisites](prerequisites.md) - What you need before you start
- [Quick Start](quick-start.md) - Get a basic setup running quickly
- [Production Setup](production-setup.md) - Guidelines for production deployments
- [DNS Configuration](dns-configuration.md) - Setting up DNS records
- [Traefik Setup](traefik-setup.md) - Configuring Traefik as a reverse proxy
- [Hetzner Deployment](hetzner-deployment.md) - Detailed guide for deploying on Hetzner Cloud
- [Post-Installation](post-installation.md) - Steps after successful installation