# OpenTalk Components

This section provides an overview of the various components that make up an OpenTalk deployment.

## Core Components

### OpenTalk Controller

The Controller is the central API and signaling service of OpenTalk. It handles user authentication, room management, meeting configuration, and coordinates the communication between clients and the media server.

- Image: `registry.opencode.de/opentalk/controller`
- Documentation: See [Controller documentation](controller.md)

### OpenTalk Web Frontend

The Web Frontend provides the user interface for OpenTalk. It's a React-based web application that communicates with the Controller API and the media server.

- Image: `registry.opencode.de/opentalk/web-frontend`

### Keycloak

Keycloak is used for authentication and user management. It provides single sign-on (SSO) capabilities and can integrate with various identity providers.

- Image: `quay.io/keycloak/keycloak`

### LiveKit

LiveKit is a WebRTC media server that handles the audio, video, and screen sharing streams between participants.

- Image: `livekit/livekit-server`

## Storage Components

### PostgreSQL

PostgreSQL is used as the primary database for OpenTalk and Keycloak.

- Image: `postgres`

### MinIO

MinIO provides S3-compatible object storage for files, recordings, and other binary data.

- Image: `minio/minio`

### Redis

Redis is used for caching and pub/sub messaging in multi-node setups.

- Image: `redis`

## Optional Components

### OpenTalk Obelisk (SIP Gateway)

Obelisk enables telephone dial-in to OpenTalk meetings via SIP.

- Image: `registry.opencode.de/opentalk/obelisk`

### OpenTalk Recorder

The Recorder component allows recording of OpenTalk meetings.

- Image: `registry.opencode.de/opentalk/recorder`

### OpenTalk SMTP Mailer

The SMTP Mailer component handles sending email notifications and invitations.

- Image: `registry.opencode.de/opentalk/smtp-mailer`

### OpenTalk Etherpad

Etherpad provides collaborative document editing within OpenTalk meetings.

- Image: `registry.opencode.de/opentalk/ot-etherpad`

### OpenTalk Spacedeck

Spacedeck provides whiteboard functionality within OpenTalk meetings.

- Image: `registry.opencode.de/opentalk/ot-spacedeck`

## Message Queue

### RabbitMQ

RabbitMQ is used for message queuing between OpenTalk components, particularly for the recorder and mailer services.

- Image: `rabbitmq`

## For More Information

For details about the official Docker images used in this setup, see the [Official Docker Images documentation](../configuration/official-images.md).