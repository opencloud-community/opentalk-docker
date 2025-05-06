# OpenTalk Docker

[![License](https://img.shields.io/badge/License-EUPL%201.2-blue.svg)](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12)

Docker and Docker Compose setup for [OpenTalk](https://opentalk.eu/), an open-source video conferencing solution designed with productivity, digital sovereignty and privacy in mind. 

This is a community-maintained project that complements the [official OpenTalk documentation](https://docs.opentalk.eu/) and is based on the [official OpenTalk Setup repository](https://gitlab.opencode.de/opentalk/ot-setup).

## Overview

This repository provides Docker Compose configurations and documentation for deploying OpenTalk and its required components:

- OpenTalk Controller (Core API and signaling service)
- OpenTalk Web Frontend
- Keycloak (Authentication)
- LiveKit (WebRTC media server)
- PostgreSQL (Database)
- MinIO (Object storage)
- Redis (For multi-node clusters)
- RabbitMQ (For messaging between services)

Optional components:
- OpenTalk Obelisk (Telephone dial-in)
- OpenTalk Recorder (Recording)
- OpenTalk SMTP Mailer (Email notifications)
- OpenTalk Etherpad (Collaborative document editing)
- OpenTalk Spacedeck (Whiteboard functionality)

## Documentation

Comprehensive documentation is available in the [docs](./docs) directory:

- [Getting Started](./docs/getting-started/README.md)
  - [Prerequisites](./docs/getting-started/prerequisites.md)
  - [Quick Start](./docs/getting-started/quick-start.md)
  - [Production Setup](./docs/getting-started/production-setup.md)
  - [DNS Configuration](./docs/getting-started/dns-configuration.md)
  - [Traefik Setup](./docs/getting-started/traefik-setup.md)
- [Components](./docs/components/README.md)
- [Configuration](./docs/configuration/README.md)
  - [Official Docker Images](./docs/configuration/official-images.md)

## Quick Start

1. Clone this repository:

```bash
git clone https://github.com/opencloud-community/opentalk-docker.git
cd opentalk-docker
```

2. Create a `.env` file from the example:

```bash
cp .env.example .env
# Edit .env with your configuration
```

3. Generate secure passwords:

```bash
# Generate random secure passwords
./scripts/generate-secrets.sh > my-secrets.env
# Review and add these to your .env file
```

4. Start OpenTalk:

```bash
# For development/testing (all services)
docker-compose up -d

# For production with Traefik and HTTPS
docker-compose -f docker-compose.yml -f docker-compose.traefik.yml up -d

# Using profiles to start only specific components
docker-compose --profile core up -d        # Start only core components
docker-compose --profile mailer up -d      # Start core + mail components
docker-compose --profile recorder up -d    # Start core + recording components
```

5. Access the setup page at:
   - Development: http://localhost
   - Production: https://yourdomain.com

6. Complete the post-installation steps:
   - Set up Keycloak users and roles
   - Test the installation
   
   See [Post-Installation Setup](./docs/getting-started/post-installation.md) for detailed instructions.

## Configuration

The Docker Compose setup is configured using environment variables and configuration files:

- `.env` file for environment variables
- `config/` directory for configuration files

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This project is licensed under the European Union Public License 1.2 (EUPL 1.2).

## Community

- Matrix Chat: [#opentalk-hosting:matrix.org](https://matrix.to/#/#opentalk-hosting:matrix.org)
- Mailing Lists: [lists.opentalk.eu](https://lists.opentalk.eu/)

## Disclaimer

This is a community-maintained project and is not officially supported by the OpenTalk GmbH. For official documentation, please visit [docs.opentalk.eu](https://docs.opentalk.eu/).

### When to use this repository vs. the official one

- **Use this repository if:**
  - You want additional deployment options and documentation
  - You're looking for a more modular Docker Compose setup with profiles
  - You prefer a GitHub-based workflow with community contributions

- **Use the official repository if:**
  - You want the most up-to-date official release
  - You need official support
  - You prefer a more streamlined deployment approach

The official OpenTalk Setup repository can be found at [gitlab.opencode.de/opentalk/ot-setup](https://gitlab.opencode.de/opentalk/ot-setup).