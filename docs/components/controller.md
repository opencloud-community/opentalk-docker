# OpenTalk Controller

The OpenTalk Controller is the core component of the OpenTalk platform. It provides the API and signaling functionality for video conferences.

## Features

- REST API for managing meetings, users, and resources
- WebSocket-based signaling for real-time communication
- Integration with Keycloak for authentication
- Integration with LiveKit for WebRTC media handling
- Database schema and migrations
- Authorization and permission management

## Docker Configuration

### Docker Image

The OpenTalk Controller is available as a Docker image. In the Docker Compose setup, it's configured as follows:

```yaml
controller:
  image: opentalk-controller:latest
  container_name: opentalk-controller
  ports:
    - "11311:11311"
  environment:
    # Environment variables detailed below
  volumes:
    - ./config/controller.toml:/app/config.toml
  depends_on:
    - postgres
    - keycloak
    - livekit
    - minio
    # Other dependencies as needed
```

### Environment Variables

The Controller can be configured using environment variables with the following pattern:

```
OPENTALK_CTRL_<section>__<field>
```

Common environment variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `OPENTALK_CTRL_DATABASE__URL` | PostgreSQL connection URL | `postgres://user:password@postgres:5432/opentalk` |
| `OPENTALK_CTRL_OIDC__AUTHORITY` | OIDC authority URL | `http://keycloak:8080/realms/opentalk` |
| `OPENTALK_CTRL_OIDC__FRONTEND__CLIENT_ID` | Frontend client ID | `OtFrontend` |
| `OPENTALK_CTRL_OIDC__CONTROLLER__CLIENT_ID` | Controller client ID | `OtBackend` |
| `OPENTALK_CTRL_OIDC__CONTROLLER__CLIENT_SECRET` | Controller client secret | `secret` |
| `OPENTALK_CTRL_LIVEKIT__PUBLIC_URL` | Public LiveKit URL | `wss://livekit.example.com` |
| `OPENTALK_CTRL_LIVEKIT__SERVICE_URL` | Internal LiveKit URL | `http://livekit:7880` |
| `OPENTALK_CTRL_MINIO__URI` | MinIO URL | `http://minio:9000` |

See the [Environment Variables](../configuration/environment-variables.md) documentation for a complete list.

## Configuration File

The Controller can also be configured using a TOML configuration file. See [Controller Configuration](../configuration/controller-config.md) for details.

## Health Checks

The Controller provides a health check endpoint at `/health` that can be used to monitor its status.

## Container Resources

Recommended resource limits for the Controller container:

- Small deployment (up to 50 concurrent users): 1 CPU, 1GB RAM
- Medium deployment (up to 200 concurrent users): 2 CPU, 2GB RAM
- Large deployment (200+ concurrent users): 4+ CPU, 4+ GB RAM

## Logs

The Controller logs to stdout/stderr, which can be accessed using Docker's logging mechanisms:

```bash
docker logs opentalk-controller
```

## Related Documentation

- [Controller Configuration](../configuration/controller-config.md)
- [Environment Variables](../configuration/environment-variables.md)
- [Production Setup](../getting-started/production-setup.md)