# Quick Start Guide

This guide will help you quickly set up a development or testing environment for OpenTalk using Docker.

> **Note**: For production deployments, please refer to the [Production Setup](production-setup.md) guide.

## Step 1: Clone the Repository

```bash
git clone https://github.com/opencloud-community/opentalk-docker.git
cd opentalk-docker
```

## Step 2: Create Environment Configuration

Create a `.env` file from the example:

```bash
cp .env.example .env
```

Edit the `.env` file to configure your deployment. At minimum, set:
- `OT_DOMAIN` - Your domain name for OpenTalk

## Step 3: Generate Secure Passwords

Use the included script to generate secure random passwords:

```bash
./scripts/generate-secrets.sh > secrets.env
```

Review the generated secrets and add them to your `.env` file.

## Step 4: Start OpenTalk

Start the core OpenTalk services:

```bash
docker-compose up -d
```

This will start the following components:
- OpenTalk Controller
- OpenTalk Web Frontend
- Keycloak (Authentication)
- PostgreSQL (Database)
- MinIO (Object Storage)
- LiveKit (WebRTC Media Server)
- Redis (For multi-node setups)
- RabbitMQ (For messaging between services)

## Step 5: Verify Installation

After a few moments, the services should be up and running. You can check the status with:

```bash
docker-compose ps
```

Access the OpenTalk web interface at:
- Development: http://localhost

## Step 6: Configure Keycloak

For a new installation, you'll need to:
1. Log in to Keycloak at http://localhost:8080 (user: `admin`, password: from your `.env` file)
2. Create a realm named `opentalk`
3. Configure client credentials
4. Create users

For detailed instructions, see the [Post-Installation](post-installation.md) guide.

## Adding Optional Components

To add optional components like email notifications or telephony:

```bash
# Add email notifications
docker-compose --profile mailer up -d

# Add telephony integration
docker-compose --profile sip up -d

# Add recording functionality
docker-compose --profile recorder up -d

# Add collaborative document editing
docker-compose --profile etherpad up -d

# Add whiteboard functionality
docker-compose --profile spacedeck up -d
```

## Next Steps

- [DNS Configuration](dns-configuration.md) - Configure DNS for your OpenTalk instance
- [Traefik Setup](traefik-setup.md) - Set up Traefik for SSL/TLS
- [Post-Installation](post-installation.md) - Complete post-installation steps

## Troubleshooting

If you encounter any issues:

1. Check container logs:
   ```bash
   docker-compose logs controller
   ```

2. Ensure all containers are running:
   ```bash
   docker-compose ps
   ```

3. Verify your environment configuration in the `.env` file

For more detailed troubleshooting, refer to the [official OpenTalk documentation](https://docs.opentalk.eu/admin/).