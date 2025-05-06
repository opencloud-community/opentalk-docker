# Prerequisites for OpenTalk Docker Setup

Before you begin deploying OpenTalk using Docker, ensure your system meets the following requirements:

> **Note**: These requirements are specific to this Docker setup. For official system requirements, please refer to the [official OpenTalk documentation](https://docs.opentalk.eu/admin/).

## Hardware Requirements

Recommended minimum specifications for a basic setup:

- **CPU:** 4 cores
- **RAM:** 8 GB
- **Disk:** 20 GB of free disk space (more if recording functionality is used)

For production environments with more users, you'll need to scale these resources accordingly.

## Software Requirements

1. **Docker Engine:**
   - Version 20.10.0 or newer
   - Installation guides:
     - [Docker for Linux](https://docs.docker.com/engine/install/)
     - [Docker for macOS](https://docs.docker.com/desktop/install/mac-install/)
     - [Docker for Windows](https://docs.docker.com/desktop/install/windows-install/)

2. **Docker Compose:**
   - Version 2.0.0 or newer (included with Docker Desktop for macOS and Windows)
   - [Installation guide for Linux](https://docs.docker.com/compose/install/linux/)

3. **Git:**
   - For cloning this repository
   - [Installation guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Network Requirements

- A public IP address or domain name for production deployments
- Open ports:
  - 80/443 for HTTP/HTTPS (web frontend)
  - 7880-7882 for LiveKit WebRTC traffic
  - 3478 for TURN server (if using built-in TURN)

## Domain and TLS Certificates

For production deployments:

- A valid domain name
- TLS certificates (Let's Encrypt or other provider)

## Next Steps

Once you have these prerequisites in place, you can proceed to the [Quick Start](quick-start.md) guide to deploy a basic OpenTalk setup.

For production environments, additional security considerations apply. See the [Production Setup](production-setup.md) guide for details.