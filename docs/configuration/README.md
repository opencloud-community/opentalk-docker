# OpenTalk Configuration

This section contains documentation about configuring OpenTalk using this Docker setup.

## Contents

- [Official Docker Images](./official-images.md) - Information about the official OpenTalk Docker images used in this setup
- Environment Variables - Common environment variables and their functions
- Configuration Files - Overview of the various configuration files

## Environment Variables

The Docker Compose setup is primarily configured using environment variables defined in the `.env` file. See the included `.env.example` file for a comprehensive list of available variables.

You can generate secure random passwords for the various services using the included script:

```bash
./scripts/generate-secrets.sh > secrets.env
```

## Configuration Files

Configuration files for the various components can be found in the `config/` directory:

- `config/controller.toml` - Configuration for the OpenTalk Controller
- `config/livekit.yaml` - Configuration for the LiveKit media server
- `config/traefik/traefik.yml` - Configuration for the Traefik reverse proxy (when using the Traefik setup)

## Profiles

The Docker Compose setup uses profiles to allow selective starting of services. Available profiles include:

- `core` - Core services (PostgreSQL, Keycloak, Controller, Frontend, etc.)
- `auth` - Authentication services (Keycloak)
- `database` - Database services (PostgreSQL)
- `storage` - Storage services (MinIO)
- `media` - Media services (LiveKit)
- `mailer` - Email notifications (SMTP Mailer)
- `recorder` - Recording functionality
- `sip` - Telephone dial-in (Obelisk)
- `etherpad` - Collaborative document editing
- `spacedeck` - Whiteboard functionality

Start services from a specific profile using:

```bash
docker-compose --profile <profile-name> up -d
```