# Official OpenTalk Docker Images

This documentation explains the use of official OpenTalk Docker images in this repository.

## Overview

OpenTalk consists of various components available as Docker images in the GitLab Container Registry. This repository uses these official images for a standards-compliant deployment.

The official images are located at:
```
registry.opencode.de/opentalk
```

## Official OpenTalk Setup Repository

This repository is based on and compatible with the official OpenTalk Setup repository:

- Official Repository: [gitlab.opencode.de/opentalk/ot-setup](https://gitlab.opencode.de/opentalk/ot-setup)
- Official docker-compose.yaml: [View on GitLab](https://gitlab.opencode.de/opentalk/ot-setup/-/blob/main/docker-compose.yaml?ref_type=heads)

While this community repository provides additional documentation and deployment options, we strive to maintain compatibility with the official setup.

## Available Components

The following components are officially provided by OpenTalk and are configured in our `docker-compose.yml`:

| Component     | Image                                          | Description                                        |
|----------------|-------------------------------------------------|---------------------------------------------------|
| controller     | registry.opencode.de/opentalk/controller       | Main component for API and business logic          |
| web-frontend   | registry.opencode.de/opentalk/web-frontend     | Web interface for users                            |
| obelisk        | registry.opencode.de/opentalk/obelisk          | SIP gateway for telephone dial-in                  |
| recorder       | registry.opencode.de/opentalk/recorder         | Recording service for meetings                     |
| smtp-mailer    | registry.opencode.de/opentalk/smtp-mailer      | Email sending service                              |
| ot-etherpad    | registry.opencode.de/opentalk/ot-etherpad      | Collaborative document tool                        |
| ot-spacedeck   | registry.opencode.de/opentalk/ot-spacedeck     | Whiteboard tool                                    |

## Docker Compose Profiles

The various components are divided into profiles to allow flexible deployment. This allows you to start exactly the services you need.

| Profile      | Description                                              |
|--------------|----------------------------------------------------------|
| core         | Basic services (Controller, Frontend, Database, etc.)    |
| mailer       | Email dispatch for invitations and notifications         |
| recorder     | Recording functionality for meetings                     |
| sip          | Telephone dial-in via SIP protocol                       |
| etherpad     | Collaborative document editing                           |
| spacedeck    | Whiteboard functionality                                 |

### Using Profiles

Here's how to start specific profiles:

```bash
# Core services only
docker-compose up -d

# With telephone dial-in
docker-compose --profile sip up -d

# With all additional features
docker-compose --profile mailer --profile recorder --profile sip --profile etherpad --profile spacedeck up -d
```

## Versions

All component images in this project now use pinned version tags for stability. We maintain a dedicated [VERSIONS.md](/VERSIONS.md) file that tracks the current versions of all components.

For specific deployments, you can override the default versions in your `.env` file:

```
CONTROLLER_IMAGE=registry.opencode.de/opentalk/controller:v0.29.4
FRONTEND_IMAGE=registry.opencode.de/opentalk/web-frontend:v2.4.3
OBELISK_IMAGE=registry.opencode.de/opentalk/obelisk:v0.19.3
```

We regularly sync our versions with those from the [official OpenTalk Setup Repository](https://gitlab.opencode.de/opentalk/ot-setup) and the [official release documentation](https://docs.opentalk.eu/releases/).

## Configuration

Detailed configuration for the various components can be found in the corresponding files under `/config`. Basic configuration is done via the Docker Compose environment variables, which can be defined in the `.env` file.