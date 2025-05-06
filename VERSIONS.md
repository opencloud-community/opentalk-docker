# Component Versions

This document tracks the current component versions used in the docker-compose configuration. These versions are pinned for stability and should be updated periodically to stay in sync with official releases.

## Core Components

| Component     | Current Version | Image |
|---------------|-----------------|-------|
| Controller    | v0.29.4         | registry.opencode.de/opentalk/controller:v0.29.4 |
| Web Frontend  | v2.4.3          | registry.opencode.de/opentalk/web-frontend:v2.4.3 |
| LiveKit       | v1.8.4          | livekit/livekit-server:v1.8.4 |
| Keycloak      | 20.0            | quay.io/keycloak/keycloak:20.0 |
| PostgreSQL    | 15-alpine       | postgres:15-alpine |
| MinIO         | RELEASE.2023-07-21T21-12-44Z | minio/minio:RELEASE.2023-07-21T21-12-44Z |
| Redis         | 7-alpine        | redis:7-alpine |
| RabbitMQ      | 3.13-management-alpine | rabbitmq:3.13-management-alpine |

## Optional Components

| Component     | Current Version | Image |
|---------------|-----------------|-------|
| Obelisk       | v0.19.3         | registry.opencode.de/opentalk/obelisk:v0.19.3 |
| Recorder      | v0.14.1         | registry.opencode.de/opentalk/recorder:v0.14.1 |
| SMTP Mailer   | v0.13.1         | registry.opencode.de/opentalk/smtp-mailer:v0.13.1 |
| Etherpad      | v2.0.0          | registry.opencode.de/opentalk/ot-etherpad:v2.0.0 |
| Spacedeck     | v2.0.1          | registry.opencode.de/opentalk/ot-spacedeck:v2.0.1 |

## Updating Versions

When updating component versions:

1. Check the [official OpenTalk releases](https://docs.opentalk.eu/releases/) for compatible versions
2. Update this document and the corresponding image tags in `docker-compose.yml`
3. Test the new versions thoroughly before deployment
4. Consider using environment variables for version overrides:

```dotenv
# .env file example for version overrides
CONTROLLER_IMAGE=registry.opencode.de/opentalk/controller:v0.29.4
FRONTEND_IMAGE=registry.opencode.de/opentalk/web-frontend:v2.4.3
LIVEKIT_IMAGE=livekit/livekit-server:v1.8.4
```

## Version sources

These versions are aligned with those used in the official [OpenTalk Setup Repository](https://gitlab.opencode.de/opentalk/ot-setup).