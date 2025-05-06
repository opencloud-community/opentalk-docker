# Environment Variables for OpenTalk Docker Setup

This document lists the environment variables that can be used to configure the various components of OpenTalk in a Docker environment.

> **Note**: For official configuration references, please visit [docs.opentalk.eu/admin/controller/core/configuration](https://docs.opentalk.eu/admin/controller/core/configuration/).

## OpenTalk Controller

The Controller can be configured using environment variables with the following pattern:

```
OPENTALK_CTRL_<section>__<field>
```

Where:
- `<section>` corresponds to a configuration section in the TOML file
- `<field>` corresponds to a field within that section
- Nested fields use additional underscores, e.g., `SECTION__SUBSECTION__FIELD`

### Database Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `OPENTALK_CTRL_DATABASE__URL` | PostgreSQL connection URL | - | Yes |
| `OPENTALK_CTRL_DATABASE__MAX_CONNECTIONS` | Maximum number of database connections | `100` | No |

### HTTP Server Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `OPENTALK_CTRL_HTTP__ADDR` | Bind address for the HTTP server | `::0` | No |
| `OPENTALK_CTRL_HTTP__PORT` | Port for the HTTP server | `11311` | No |

### OIDC Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `OPENTALK_CTRL_OIDC__AUTHORITY` | Base URL for the OIDC authority | - | Yes |
| `OPENTALK_CTRL_OIDC__FRONTEND__AUTHORITY` | OIDC authority for the frontend | Value from `OIDC__AUTHORITY` | No |
| `OPENTALK_CTRL_OIDC__FRONTEND__CLIENT_ID` | Client ID for the frontend | - | Yes |
| `OPENTALK_CTRL_OIDC__CONTROLLER__AUTHORITY` | OIDC authority for the controller | Value from `OIDC__AUTHORITY` | No |
| `OPENTALK_CTRL_OIDC__CONTROLLER__CLIENT_ID` | Client ID for the controller | - | Yes |
| `OPENTALK_CTRL_OIDC__CONTROLLER__CLIENT_SECRET` | Client secret for the controller | - | Yes |

### User Search Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `OPENTALK_CTRL_USER_SEARCH__BACKEND` | Backend for user search | `keycloak_webapi` | No |
| `OPENTALK_CTRL_USER_SEARCH__API_BASE_URL` | Base URL for the user search API | - | Yes |
| `OPENTALK_CTRL_USER_SEARCH__USERS_FIND_BEHAVIOR` | Behavior for the /users/find endpoint | `from_user_search_backend` | No |

### LiveKit Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `OPENTALK_CTRL_LIVEKIT__PUBLIC_URL` | Public WebSocket URL for LiveKit | - | Yes |
| `OPENTALK_CTRL_LIVEKIT__SERVICE_URL` | Service URL for LiveKit | - | Yes |
| `OPENTALK_CTRL_LIVEKIT__API_KEY` | API key for LiveKit | - | Yes |
| `OPENTALK_CTRL_LIVEKIT__API_SECRET` | API secret for LiveKit | - | Yes |

### MinIO Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `OPENTALK_CTRL_MINIO__URI` | URI for MinIO | - | Yes |
| `OPENTALK_CTRL_MINIO__BUCKET` | Bucket name in MinIO | `controller` | No |
| `OPENTALK_CTRL_MINIO__ACCESS_KEY` | Access key for MinIO | - | Yes |
| `OPENTALK_CTRL_MINIO__SECRET_KEY` | Secret key for MinIO | - | Yes |

### Redis Configuration (for multi-node setups)

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `OPENTALK_CTRL_REDIS__URL` | URL for Redis | - | No (Yes for clustered setup) |

### RabbitMQ Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `OPENTALK_CTRL_RABBIT_MQ__URL` | URL for RabbitMQ | - | No |
| `OPENTALK_CTRL_RABBIT_MQ__MAIL_TASK_QUEUE` | Queue for the mailer | - | No (Yes if using mailer) |
| `OPENTALK_CTRL_RABBIT_MQ__RECORDING_TASK_QUEUE` | Queue for the recorder | - | No (Yes if using recorder) |

## Keycloak Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `KEYCLOAK_ADMIN` | Admin username | - | Yes |
| `KEYCLOAK_ADMIN_PASSWORD` | Admin password | - | Yes |
| `KC_DB` | Database type | `postgres` | No |
| `KC_DB_URL` | Database URL | - | Yes (for Postgres) |
| `KC_DB_USERNAME` | Database username | - | Yes (for Postgres) |
| `KC_DB_PASSWORD` | Database password | - | Yes (for Postgres) |

## LiveKit Configuration

LiveKit is typically configured via a configuration file rather than environment variables. See [LiveKit Configuration](livekit-config.md) for details.

## Frontend Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `API_URL` | URL for the OpenTalk API | - | Yes |
| `OIDC_AUTHORITY` | OIDC authority URL | - | Yes |
| `OIDC_CLIENT_ID` | OIDC client ID | - | Yes |

## Database Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `POSTGRES_USER` | PostgreSQL username | - | Yes |
| `POSTGRES_PASSWORD` | PostgreSQL password | - | Yes |
| `POSTGRES_DB` | PostgreSQL database name | - | Yes |

## MinIO Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `MINIO_ROOT_USER` | MinIO root user | - | Yes |
| `MINIO_ROOT_PASSWORD` | MinIO root password | - | Yes |

## RabbitMQ Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `RABBITMQ_DEFAULT_USER` | RabbitMQ username | - | Yes |
| `RABBITMQ_DEFAULT_PASS` | RabbitMQ password | - | Yes |

## Optional Components

### SMTP Mailer

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `SMTP_HOST` | SMTP server hostname | - | Yes |
| `SMTP_PORT` | SMTP server port | `587` | No |
| `SMTP_USERNAME` | SMTP username | - | Yes |
| `SMTP_PASSWORD` | SMTP password | - | Yes |
| `SMTP_FROM` | From email address | - | Yes |
| `RABBITMQ_URL` | RabbitMQ URL | - | Yes |
| `RABBITMQ_QUEUE` | RabbitMQ queue name | - | Yes |

### Recorder

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `RABBITMQ_URL` | RabbitMQ URL | - | Yes |
| `RABBITMQ_QUEUE` | RabbitMQ queue name | - | Yes |
| `CONTROLLER_URL` | Controller URL | - | Yes |
| `LIVEKIT_URL` | LiveKit URL | - | Yes |
| `RECORDER_OUTPUT_DIR` | Directory for recordings | - | Yes |