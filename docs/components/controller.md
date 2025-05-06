# OpenTalk Controller

The OpenTalk Controller is the central component of the OpenTalk platform. It provides the API for all client applications and coordinates the communication between clients and external services.

## Features

- RESTful API for room management, user authentication, and meeting configuration
- Real-time signaling for WebRTC media connections
- Integration with Keycloak for authentication and user management
- Integration with LiveKit for WebRTC media services
- Integration with MinIO for file storage
- Integration with various optional components (Etherpad, Spacedeck, etc.)

## Configuration

The Controller is configured using a combination of the `config/controller.toml` file and environment variables.

### Environment Variables

Key environment variables include:

- `OPENTALK_CTRL_DATABASE__URL`: PostgreSQL connection string
- `OPENTALK_CTRL_HTTP__PORT`: HTTP port to listen on
- `OPENTALK_CTRL_OIDC__AUTHORITY`: OIDC issuer URL
- `OPENTALK_CTRL_OIDC__FRONTEND__CLIENT_ID`: OIDC client ID for the frontend
- `OPENTALK_CTRL_OIDC__CONTROLLER__CLIENT_ID`: OIDC client ID for the controller
- `OPENTALK_CTRL_OIDC__CONTROLLER__CLIENT_SECRET`: OIDC client secret for the controller
- `OPENTALK_CTRL_LIVEKIT__PUBLIC_URL`: Public URL for LiveKit
- `OPENTALK_CTRL_LIVEKIT__SERVICE_URL`: Service URL for LiveKit
- `OPENTALK_CTRL_LIVEKIT__API_KEY`: LiveKit API key
- `OPENTALK_CTRL_LIVEKIT__API_SECRET`: LiveKit API secret
- `OPENTALK_CTRL_MINIO__URI`: MinIO URI
- `OPENTALK_CTRL_MINIO__BUCKET`: MinIO bucket name
- `OPENTALK_CTRL_MINIO__ACCESS_KEY`: MinIO access key
- `OPENTALK_CTRL_MINIO__SECRET_KEY`: MinIO secret key

### Config File

The `controller.toml` file allows for more detailed configuration. Examples and documentation can be found in:

- [Configuration Overview](https://docs.opentalk.eu/admin/controller/core/configuration/)
- [Database Configuration](https://docs.opentalk.eu/admin/controller/core/database/)
- [HTTP Server Configuration](https://docs.opentalk.eu/admin/controller/core/http_server/)
- [Identity Provider Configuration](https://docs.opentalk.eu/admin/controller/core/oidc/)
- [LiveKit Configuration](https://docs.opentalk.eu/admin/controller/core/livekit/)
- [File Storage (MinIO) Configuration](https://docs.opentalk.eu/admin/controller/core/minio/)
- [Message Queue (RabbitMQ) Configuration](https://docs.opentalk.eu/admin/controller/core/rabbitmq/)

You can also find example configuration files in the [official OpenTalk Setup repository](https://gitlab.opencode.de/opentalk/ot-setup/-/tree/main/extras/opentalk-samples).

## Docker Image

The official Docker image for the Controller is used with a specific version tag:

```
registry.opencode.de/opentalk/controller:v0.29.4
```

The current version can be found in our [VERSIONS.md](/VERSIONS.md) file. 

You can override this version in your `.env` file:

```
CONTROLLER_IMAGE=registry.opencode.de/opentalk/controller:v0.29.5
```

## Scaling

For high-availability and scaling, the Controller can be deployed with multiple instances behind a load balancer. In this scenario, Redis is required for shared state storage.

## Health Checks

The Controller provides a health check endpoint at `/health` that can be used by container orchestrators and load balancers.

## Logs

Logs are output to stdout/stderr and can be viewed using:

```bash
docker logs opentalk-controller
```

## API Documentation

API documentation is available at `/swagger-ui/` when the Controller is running with development settings.