#!/bin/bash
#
# Script to check if all required DNS entries for OpenTalk are properly configured
# 
# Usage: ./check-dns.sh example.com
#

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if dig is installed
if ! command -v dig &> /dev/null; then
    echo -e "${RED}Error: 'dig' command is not installed. Please install bind-utils or dnsutils package.${NC}"
    exit 1
fi

# Check if domain was provided
if [ $# -ne 1 ]; then
    echo -e "${RED}Error: No domain specified.${NC}"
    echo "Usage: $0 example.com"
    exit 1
fi

DOMAIN=$1
echo -e "${YELLOW}Checking DNS configuration for ${DOMAIN}...${NC}"

# Function to check A record
check_a_record() {
    local subdomain=$1
    local hostname
    
    if [ "$subdomain" == "@" ]; then
        hostname="${DOMAIN}"
    else
        hostname="${subdomain}.${DOMAIN}"
    fi
    
    echo -e "\n${YELLOW}Checking A record for ${hostname}...${NC}"
    
    # Try to resolve the hostname
    if host_ip=$(dig +short A "$hostname"); then
        if [ -n "$host_ip" ]; then
            echo -e "${GREEN}✓ Found A record for ${hostname}: ${host_ip}${NC}"
            return 0
        else
            echo -e "${RED}✗ No A record found for ${hostname}${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Failed to query DNS for ${hostname}${NC}"
        return 1
    fi
}

# Function to check AAAA record
check_aaaa_record() {
    local subdomain=$1
    local hostname
    
    if [ "$subdomain" == "@" ]; then
        hostname="${DOMAIN}"
    else
        hostname="${subdomain}.${DOMAIN}"
    fi
    
    echo -e "\n${YELLOW}Checking AAAA record for ${hostname}...${NC}"
    
    # Try to resolve the hostname
    if host_ip=$(dig +short AAAA "$hostname"); then
        if [ -n "$host_ip" ]; then
            echo -e "${GREEN}✓ Found AAAA record for ${hostname}: ${host_ip}${NC}"
            return 0
        else
            echo -e "${YELLOW}ℹ No AAAA record found for ${hostname} (IPv6 not configured)${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Failed to query DNS for ${hostname}${NC}"
        return 1
    fi
}

# Function to check CNAME record
check_cname_record() {
    local subdomain=$1
    local hostname
    
    if [ "$subdomain" == "@" ]; then
        hostname="${DOMAIN}"
    else
        hostname="${subdomain}.${DOMAIN}"
    fi
    
    echo -e "\n${YELLOW}Checking CNAME record for ${hostname}...${NC}"
    
    # Try to resolve the CNAME
    if cname=$(dig +short CNAME "$hostname"); then
        if [ -n "$cname" ]; then
            echo -e "${GREEN}✓ Found CNAME record for ${hostname}: ${cname}${NC}"
            return 0
        else
            echo -e "${YELLOW}ℹ No CNAME record found for ${hostname}${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Failed to query DNS for ${hostname}${NC}"
        return 1
    fi
}

# Function to check SRV record
check_srv_record() {
    local service=$1
    local protocol=$2
    local name="_${service}._${protocol}.${DOMAIN}"
    
    echo -e "\n${YELLOW}Checking SRV record for ${name}...${NC}"
    
    # Try to resolve the SRV record
    if srv_record=$(dig +short SRV "$name"); then
        if [ -n "$srv_record" ]; then
            echo -e "${GREEN}✓ Found SRV record for ${name}: ${srv_record}${NC}"
            return 0
        else
            echo -e "${RED}✗ No SRV record found for ${name}${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Failed to query DNS for ${name}${NC}"
        return 1
    fi
}

# Function to check if a record is resolvable
check_resolvable() {
    local hostname=$1
    
    if host "$hostname" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Hostname ${hostname} is resolvable${NC}"
        return 0
    else
        echo -e "${RED}✗ Hostname ${hostname} is not resolvable${NC}"
        return 1
    fi
}

# Required A records for OpenTalk
REQUIRED_A_RECORDS=(
    "@"              # Main domain
    "api"            # OpenTalk Controller API
    "keycloak"       # Keycloak authentication
    "livekit"        # LiveKit media server
)

# Optional A records
OPTIONAL_A_RECORDS=(
    "minio"          # MinIO object storage
    "traefik"        # Traefik dashboard
    "rabbitmq"       # RabbitMQ management
    "sip"            # SIP server (for Obelisk)
    "recordings"     # Recordings access
)

# Required SRV records (if using Obelisk)
OPTIONAL_SRV_RECORDS=(
    "sip:udp"        # SIP over UDP
)

# CNAME records that could be used instead of A records
CNAME_ALTERNATIVES=(
    "api"
    "keycloak"
    "livekit"
    "minio"
    "traefik"
    "rabbitmq"
    "recordings"
    "sip"
)

# Check required A records
echo -e "\n${YELLOW}=== Checking Required A Records ===${NC}"
required_failures=0

for record in "${REQUIRED_A_RECORDS[@]}"; do
    # If A record doesn't exist, check if CNAME exists as an alternative
    if ! check_a_record "$record"; then
        if [[ "$record" != "@" && " ${CNAME_ALTERNATIVES[*]} " =~ " $record " ]]; then
            if check_cname_record "$record"; then
                echo -e "${GREEN}✓ Found CNAME instead of A record for ${record}.${DOMAIN}${NC}"
                continue
            fi
        fi
        ((required_failures++))
    fi
done

# Check optional A records
echo -e "\n${YELLOW}=== Checking Optional A Records ===${NC}"
optional_a_failures=0

for record in "${OPTIONAL_A_RECORDS[@]}"; do
    # If A record doesn't exist, check if CNAME exists as an alternative
    if ! check_a_record "$record"; then
        if check_cname_record "$record"; then
            echo -e "${GREEN}✓ Found CNAME instead of A record for ${record}.${DOMAIN}${NC}"
            continue
        fi
        ((optional_a_failures++))
    fi
done

# Check IPv6 (AAAA) records
echo -e "\n${YELLOW}=== Checking for IPv6 Support (AAAA Records) ===${NC}"
ipv6_support=false

# Check main domain for AAAA
if check_aaaa_record "@"; then
    ipv6_support=true
    echo -e "${GREEN}✓ IPv6 support detected!${NC}"
    
    # Check if wildcard AAAA record exists
    if check_aaaa_record "*"; then
        echo -e "${GREEN}✓ Wildcard AAAA record found. This covers all subdomains for IPv6.${NC}"
    else
        echo -e "${YELLOW}ℹ Individual AAAA records for subdomains may be required for full IPv6 support.${NC}"
    fi
else
    echo -e "${YELLOW}ℹ No IPv6 support detected. This is optional but recommended.${NC}"
fi

# Check optional SRV records
echo -e "\n${YELLOW}=== Checking Optional SRV Records (for telephony) ===${NC}"
optional_srv_failures=0

for record in "${OPTIONAL_SRV_RECORDS[@]}"; do
    service=${record%:*}
    protocol=${record#*:}
    if ! check_srv_record "$service" "$protocol"; then
        ((optional_srv_failures++))
    fi
done

# Check if wildcard A record exists (alternative to individual records)
echo -e "\n${YELLOW}=== Checking for Wildcard Record ===${NC}"
if check_a_record "*"; then
    echo -e "${GREEN}✓ Wildcard A record found. This can replace individual subdomain records.${NC}"
    has_wildcard=true
else
    echo -e "${YELLOW}ℹ No wildcard A record found. Individual records or CNAMEs are required.${NC}"
    has_wildcard=false
fi

# Check external connectivity
echo -e "\n${YELLOW}=== Checking External Connectivity ===${NC}"
if check_resolvable "${DOMAIN}"; then
    echo -e "${GREEN}✓ Main domain is accessible from the internet${NC}"
else
    echo -e "${RED}✗ Main domain is not accessible from the internet${NC}"
    ((required_failures++))
fi

# Print summary
echo -e "\n${YELLOW}=== Summary ===${NC}"
if [ "$required_failures" -eq 0 ]; then
    echo -e "${GREEN}✓ All required DNS records are properly configured.${NC}"
else
    echo -e "${RED}✗ ${required_failures} required DNS records are missing.${NC}"
fi

if [ "$optional_a_failures" -gt 0 ]; then
    if [ "$has_wildcard" = true ]; then
        echo -e "${GREEN}ℹ ${optional_a_failures} optional A records are missing, but the wildcard record covers them.${NC}"
    else
        echo -e "${YELLOW}ℹ ${optional_a_failures} optional A records are missing. These may be needed depending on your setup.${NC}"
    fi
fi

if [ "$optional_srv_failures" -gt 0 ]; then
    echo -e "${YELLOW}ℹ ${optional_srv_failures} optional SRV records are missing. These are only needed for telephony features.${NC}"
fi

# Final status
if [ "$required_failures" -eq 0 ]; then
    echo -e "\n${GREEN}DNS configuration for OpenTalk looks good! You can proceed with the installation.${NC}"
    exit 0
else
    echo -e "\n${RED}Please fix the missing required DNS records before proceeding with the installation.${NC}"
    exit 1
fi