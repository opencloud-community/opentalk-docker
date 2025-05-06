# OpenTalk Docker

[![License](https://img.shields.io/badge/License-EUPL%201.2-blue.svg)](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12)

Docker and Docker Compose setup for [OpenTalk](https://opentalk.eu/), an open-source video conferencing solution designed with productivity, digital sovereignty and privacy in mind.

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

## Documentation

Comprehensive documentation is available in the [docs](./docs) directory:

- [Getting Started](./docs/getting-started/README.md)
  - [Prerequisites](./docs/getting-started/prerequisites.md)
  - [Quick Start](./docs/getting-started/quick-start.md)
  - [Production Setup](./docs/getting-started/production-setup.md)
- [Components](./docs/components/README.md)
- [Configuration](./docs/configuration/README.md)

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

3. Start OpenTalk:

```bash
docker-compose up -d
```

4. Access the setup page at http://localhost

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