# Traefik Reverse Proxy Setup for OpenTalk

This guide explains how to set up Traefik as a reverse proxy for OpenTalk, providing automatic HTTPS with Let's Encrypt certificates.

> **Note**: This is a community-provided extension to the [official OpenTalk documentation](https://docs.opentalk.eu/), focusing on production deployment with Traefik.

## What is Traefik?

[Traefik](https://traefik.io/) is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy. It automatically integrates with Docker and can request and renew Let's Encrypt certificates.

## Benefits of Using Traefik with OpenTalk

- Automatic HTTPS with Let's Encrypt certificates
- Simplified routing to multiple services
- Automatic certificate renewal
- Built-in monitoring and metrics
- Docker integration

## Installation

The `docker-compose.traefik.yml` file in this repository includes a complete Traefik configuration for OpenTalk. You can use it by running:

```bash
docker-compose -f docker-compose.yml -f docker-compose.traefik.yml up -d
```

## Configuration

### Prerequisites

1. A domain name pointing to your server's IP address
2. DNS records set up as described in [DNS Configuration](dns-configuration.md)
3. Ports 80 and 443 open on your firewall

### Environment Variables

Configure the following environment variables in your `.env` file:

```
# Domain configuration
DOMAIN=example.com

# Traefik configuration
TRAEFIK_ACME_EMAIL=your-email@example.com
```

### Traefik Dashboard

The Traefik dashboard is available at `https://traefik.example.com` (if enabled). You can use it to monitor routes, services, and certificate status.

## How It Works

Traefik works by:

1. Routing incoming requests to the appropriate service based on the hostname
2. Automatically requesting and renewing Let's Encrypt certificates
3. Providing HTTPS termination for all services
4. Load balancing requests across multiple instances (if configured)

## Security Considerations

The provided Traefik configuration includes:

- Automatic HTTPS redirection
- HTTP Strict Transport Security (HSTS)
- Modern TLS configuration (TLS 1.2+ only)
- Security headers

## Debugging

If you encounter issues with Traefik:

1. Check the Traefik logs:
   ```bash
   docker-compose logs traefik
   ```

2. Verify that your DNS records are correctly configured and have propagated
3. Check that ports 80 and 443 are open and not used by other services
4. Ensure that Let's Encrypt rate limits have not been exceeded

## Further Customization

You can further customize the Traefik configuration by:

1. Editing the `traefik.yml` configuration file in the `config/traefik/` directory
2. Modifying labels in the `docker-compose.traefik.yml` file
3. Adding additional middleware for caching, authentication, etc.

For more information, see the [Traefik documentation](https://doc.traefik.io/traefik/).