# DNS Configuration for OpenTalk

When setting up OpenTalk with a domain name for production use, you need to configure various DNS records. This guide explains the necessary DNS entries and their purpose.

> **Note**: This guide supplements the [official OpenTalk documentation](https://docs.opentalk.eu/) with DNS-specific guidance for production deployments.

## Required DNS Entries

For a complete OpenTalk installation with all components, you should configure the following DNS records:

| Type | Hostname | Value | Purpose |
|------|----------|-------|---------|
| A | opentalk.example.com | Server IP | Main entry point for OpenTalk web frontend |
| A | api.example.com | Server IP | OpenTalk Controller API |
| A | keycloak.example.com | Server IP | Authentication server |
| A | livekit.example.com | Server IP | WebRTC media server |
| A | minio.example.com | Server IP | (Optional) Object storage access |
| A | traefik.example.com | Server IP | (Optional) Traefik dashboard |
| A | rabbitmq.example.com | Server IP | (Optional) RabbitMQ management |
| A | recordings.example.com | Server IP | (Optional) Access to meeting recordings |

Replace `example.com` with your actual domain and `Server IP` with your server's public IP address.

## IPv6 Support (AAAA Records)

To provide full IPv6 support, you should configure equivalent AAAA records for the above hostnames:

| Type | Hostname | Value | Purpose |
|------|----------|-------|---------|
| AAAA | opentalk.example.com | IPv6 Address | IPv6 access to main domain |
| AAAA | api.example.com | IPv6 Address | IPv6 access to API |
| AAAA | *.example.com | IPv6 Address | IPv6 access to all subdomains |

## Alternative: CNAME Records

Instead of creating individual A records for each subdomain, you can use CNAME records that point to your main domain. This approach is especially useful if your server IP might change in the future.

| Type | Hostname | Value | Purpose |
|------|----------|-------|---------|
| A | opentalk.example.com | Server IP | Main entry point |
| CNAME | api.example.com | opentalk.example.com | Points to main domain |
| CNAME | keycloak.example.com | opentalk.example.com | Points to main domain |
| CNAME | livekit.example.com | opentalk.example.com | Points to main domain |
| CNAME | minio.example.com | opentalk.example.com | Points to main domain |

**Note**: This approach requires your reverse proxy (Traefik) to properly handle the different hostnames.

## Optional DNS Entries for SIP/Telephony

If you're using OpenTalk Obelisk for telephone dial-in:

| Type | Hostname | Value | Purpose |
|------|----------|-------|---------|
| SRV | _sip._udp.example.com | 10 10 5060 sip.example.com. | SIP service discovery |
| A | sip.example.com | Server IP | SIP server hostname |

## Email-Related DNS Entries (for SMTP Mailer)

If you're using the OpenTalk SMTP Mailer and sending emails from your domain:

| Type | Hostname | Value | Purpose |
|------|----------|-------|---------|
| TXT | example.com | v=spf1 ip4:YOUR_SERVER_IP ~all | SPF record for email authentication |
| TXT | mail._domainkey.example.com | v=DKIM1; k=rsa; p=YOUR_DKIM_KEY | DKIM record for email authentication |

## Wildcard Certificate Option

As an alternative to creating individual DNS records for each service, you can create a single wildcard record:

| Type | Hostname | Value | Purpose |
|------|----------|-------|---------|
| A | *.example.com | Server IP | Wildcard record for all subdomains |

This allows you to use a wildcard certificate for all services, simplifying TLS certificate management.

## DNS Propagation

After setting up your DNS records, it may take some time (up to 48 hours, but usually much less) for the changes to propagate throughout the internet. You can check propagation status using tools like:

- [DNSChecker](https://dnschecker.org/)
- [MXToolbox](https://mxtoolbox.com/DNSLookup.aspx)
- [What's My DNS](https://whatsmydns.net/)

## Configuring OpenTalk with Your Domain

Once your DNS records are set up, you need to update your `.env` file with the appropriate domains:

```
# Domain configuration
DOMAIN=example.com

# Public URLs
CONTROLLER_PUBLIC_URL=https://api.example.com
KEYCLOAK_PUBLIC_URL=https://keycloak.example.com
LIVEKIT_PUBLIC_URL=wss://livekit.example.com
```

See the [Environment Variables](../configuration/environment-variables.md) documentation for more details.

## Helper Scripts

We provide helper scripts to simplify DNS configuration:

### DNS Check Script

This script checks if all required DNS entries are properly configured:

```bash
./scripts/check-dns.sh example.com
```

The script verifies:
- A records for required domains
- CNAME records (as alternatives to A records)
- AAAA records for IPv6 support
- SRV records for telephony
- Wildcard records

### Cloudflare Zone Generator

This script generates a Cloudflare zone file with all necessary DNS records:

```bash
# Basic usage (A records only)
./scripts/generate-cloudflare-zone.sh example.com 203.0.113.1 > cloudflare-zone.json

# With IPv6 support
./scripts/generate-cloudflare-zone.sh example.com 203.0.113.1 2001:db8::1 > cloudflare-zone.json

# With CNAME records instead of A records
./scripts/generate-cloudflare-zone.sh example.com 203.0.113.1 "" true 1 cname > cloudflare-zone.json

# Full options
./scripts/generate-cloudflare-zone.sh example.com 203.0.113.1 2001:db8::1 true 1 both > cloudflare-zone.json
```

Parameters:
- `example.com`: Your domain name
- `203.0.113.1`: Your server's IPv4 address
- `2001:db8::1`: (Optional) Your server's IPv6 address
- `true`: (Optional) Whether to proxy through Cloudflare (true/false)
- `1`: (Optional) TTL value (1 for auto, or 60-86400 seconds)
- `mode`: (Optional) DNS record mode ('a' for A records, 'cname' for CNAME records, 'both' for both)

The script provides instructions for importing the generated file into your Cloudflare account.