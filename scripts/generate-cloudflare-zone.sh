#!/bin/bash
#
# Script to generate a Cloudflare zone file for OpenTalk
# 
# Usage: ./generate-cloudflare-zone.sh example.com 203.0.113.1 > cloudflare-zone.txt
#

set -e

# Check if parameters were provided
if [ $# -lt 2 ]; then
    echo "Error: Missing required parameters."
    echo "Usage: $0 domain ip_address [ipv6_address] [proxied] [ttl] [mode]"
    echo "       domain       - Your domain name (e.g., example.com)"
    echo "       ip_address   - IPv4 address for all records"
    echo "       ipv6_address - (Optional) IPv6 address for AAAA records"
    echo "       proxied      - (Optional) Whether to proxy records through Cloudflare (true/false, default: true)"
    echo "       ttl          - (Optional) TTL value (60-86400 seconds, or 1 for auto, default: 1)"
    echo "       mode         - (Optional) DNS record mode ('a' for A records, 'cname' for CNAME, 'both' for both, default: 'a')"
    echo ""
    echo "Example with IPv6 and CNAME mode:"
    echo "       $0 example.com 203.0.113.1 2001:db8::1 true 1 cname"
    exit 1
fi

DOMAIN=$1
IP_ADDRESS=$2
IPV6_ADDRESS=${3:-""}
PROXIED=${4:-true}
TTL=${5:-1}
MODE=${6:-"a"}

# Validate IP address format
if ! [[ $IP_ADDRESS =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid IPv4 address format."
    exit 1
fi

# Validate IPv6 address if provided
if [[ -n "$IPV6_ADDRESS" ]] && ! [[ $IPV6_ADDRESS =~ ^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$ ]]; then
    echo "Warning: The provided IPv6 address format may be invalid. Continuing anyway."
fi

# Validate mode
if [[ "$MODE" != "a" && "$MODE" != "cname" && "$MODE" != "both" ]]; then
    echo "Error: Mode must be 'a', 'cname', or 'both'."
    exit 1
fi

# Validate TTL
if ! [[ $TTL =~ ^[0-9]+$ ]] || [[ $TTL -ne 1 && ($TTL -lt 60 || $TTL -gt 86400) ]]; then
    echo "Error: TTL must be 1 (auto) or between 60-86400 seconds."
    exit 1
fi

# Validate proxied
if [[ "$PROXIED" != "true" && "$PROXIED" != "false" ]]; then
    echo "Error: proxied must be 'true' or 'false'."
    exit 1
fi

# Generate JSON template for an A record
generate_a_record() {
    local name=$1
    local content=$2
    local ttl=$3
    local proxied=$4

    # For root domain, use @ symbol
    if [[ "$name" == "$DOMAIN" ]]; then
        name="@"
    else
        # Remove domain part from name
        name="${name%%.$DOMAIN}"
    fi

    cat <<EOF
{
  "type": "A",
  "name": "$name",
  "content": "$content",
  "ttl": $ttl,
  "proxied": $proxied
}
EOF
}

# Generate JSON template for an AAAA record
generate_aaaa_record() {
    local name=$1
    local content=$2
    local ttl=$3
    local proxied=$4

    # For root domain, use @ symbol
    if [[ "$name" == "$DOMAIN" ]]; then
        name="@"
    else
        # Remove domain part from name
        name="${name%%.$DOMAIN}"
    fi

    cat <<EOF
{
  "type": "AAAA",
  "name": "$name",
  "content": "$content",
  "ttl": $ttl,
  "proxied": $proxied
}
EOF
}

# Generate JSON template for a CNAME record
generate_cname_record() {
    local name=$1
    local content=$2
    local ttl=$3
    local proxied=$4

    # Remove domain part from name (can't be root)
    name="${name%%.$DOMAIN}"

    cat <<EOF
{
  "type": "CNAME",
  "name": "$name",
  "content": "$content",
  "ttl": $ttl,
  "proxied": $proxied
}
EOF
}

# Generate JSON template for a SRV record
generate_srv_record() {
    local service=$1
    local protocol=$2
    local priority=$3
    local weight=$4
    local port=$5
    local target=$6
    local ttl=$7

    cat <<EOF
{
  "type": "SRV",
  "name": "_${service}._${protocol}",
  "content": "${priority} ${weight} ${port} ${target}",
  "ttl": $ttl,
  "proxied": false
}
EOF
}

# Generate JSON template for a TXT record
generate_txt_record() {
    local name=$1
    local content=$2
    local ttl=$3

    # For root domain, use @ symbol
    if [[ "$name" == "$DOMAIN" ]]; then
        name="@"
    else
        # Remove domain part from name
        name="${name%%.$DOMAIN}"
    fi

    cat <<EOF
{
  "type": "TXT",
  "name": "$name",
  "content": "$content",
  "ttl": $ttl,
  "proxied": false
}
EOF
}

# Begin JSON output
echo "["

# Define records
MAIN_DOMAIN="${DOMAIN}"            # Root domain
SUBDOMAINS=(
    "api"                          # OpenTalk Controller API
    "keycloak"                     # Keycloak authentication
    "livekit"                      # LiveKit media server
    "minio"                        # MinIO object storage
    "traefik"                      # Traefik dashboard
    "rabbitmq"                     # RabbitMQ management
    "recordings"                   # Recordings access
    "sip"                          # SIP server (for Obelisk)
)

# Counter for commas
record_count=0
total_records=1  # Start with one for the main domain A record

# Add counts for subdomain records
if [[ "$MODE" == "a" || "$MODE" == "both" ]]; then
    total_records=$((total_records + ${#SUBDOMAINS[@]}))
fi
if [[ "$MODE" == "cname" || "$MODE" == "both" ]]; then
    total_records=$((total_records + ${#SUBDOMAINS[@]}))
fi

# If we have IPv6, add those records
if [[ -n "$IPV6_ADDRESS" ]]; then
    if [[ "$MODE" == "a" || "$MODE" == "both" ]]; then
        total_records=$((total_records + 1 + ${#SUBDOMAINS[@]}))  # Main domain AAAA + subdomains
    fi
fi

# Add wildcard record to count
total_records=$((total_records + 1))

# Add SRV record to count
total_records=$((total_records + 1))

# Generate A record for main domain
generate_a_record "$MAIN_DOMAIN" "$IP_ADDRESS" "$TTL" "$PROXIED"
record_count=$((record_count + 1))
if [[ $record_count -lt $total_records ]]; then echo ","; fi

# Generate AAAA record for main domain if IPv6 is provided
if [[ -n "$IPV6_ADDRESS" ]]; then
    generate_aaaa_record "$MAIN_DOMAIN" "$IPV6_ADDRESS" "$TTL" "$PROXIED"
    record_count=$((record_count + 1))
    if [[ $record_count -lt $total_records ]]; then echo ","; fi
fi

# Generate records for subdomains
for subdomain in "${SUBDOMAINS[@]}"; do
    # Create A records if mode is 'a' or 'both'
    if [[ "$MODE" == "a" || "$MODE" == "both" ]]; then
        generate_a_record "${subdomain}.${DOMAIN}" "$IP_ADDRESS" "$TTL" "$PROXIED"
        record_count=$((record_count + 1))
        if [[ $record_count -lt $total_records ]]; then echo ","; fi
        
        # Create AAAA records if IPv6 is provided
        if [[ -n "$IPV6_ADDRESS" ]]; then
            generate_aaaa_record "${subdomain}.${DOMAIN}" "$IPV6_ADDRESS" "$TTL" "$PROXIED"
            record_count=$((record_count + 1))
            if [[ $record_count -lt $total_records ]]; then echo ","; fi
        fi
    fi
    
    # Create CNAME records if mode is 'cname' or 'both'
    if [[ "$MODE" == "cname" || "$MODE" == "both" ]]; then
        # Skip CNAME for main domain as it's not valid
        if [[ "$subdomain" != "@" ]]; then
            generate_cname_record "${subdomain}.${DOMAIN}" "$MAIN_DOMAIN" "$TTL" "$PROXIED"
            record_count=$((record_count + 1))
            if [[ $record_count -lt $total_records ]]; then echo ","; fi
        fi
    fi
done

# Generate wildcard record (optional but recommended)
if [[ "$MODE" == "a" || "$MODE" == "both" ]]; then
    generate_a_record "*.${DOMAIN}" "$IP_ADDRESS" "$TTL" "$PROXIED"
    record_count=$((record_count + 1))
    if [[ $record_count -lt $total_records ]]; then echo ","; fi
fi

# SRV record for SIP (only if using Obelisk for telephony)
generate_srv_record "sip" "udp" "10" "10" "5060" "sip.${DOMAIN}" "$TTL"

# End JSON output
echo "]"

cat <<EOF

# -----------------------------------------------------------
# Instructions:
# -----------------------------------------------------------
# 1. Save this output to a file (e.g., cloudflare-zone.json)
# 2. Import into Cloudflare using the API or Dashboard
# 
# For API import (requires Cloudflare API token with Zone.DNS permissions):
# curl -X POST "https://api.cloudflare.com/client/v4/zones/YOUR_ZONE_ID/dns_records/import" \\
#   -H "Authorization: Bearer YOUR_API_TOKEN" \\
#   -F "file=@cloudflare-zone.json"
#
# For manual import via Dashboard:
# 1. Go to your domain in Cloudflare Dashboard
# 2. Navigate to DNS > Records
# 3. Add each record manually
# -----------------------------------------------------------
EOF