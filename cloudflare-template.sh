#!/bin/bash

# ========== USER CONFIGURATION ==========
auth_email=""                  # Your Cloudflare account email
auth_key=""                    # Your API Token (recommended) or Global API Key
auth_method="token"            # "token" or "global"
zone_identifier=""             # Your Cloudflare zone ID
record_name="nas.yourdomain.com"  # << CHANGE THIS PER PC: subdomain to update
sitename="NAS"                 # << Optional: Just a label for logs/alerts
ttl=3600
proxy="false"                  # true if you want Cloudflare proxy (orange cloud)

# ========== GET PUBLIC IP ==========
ip=$(curl -s -4 https://cloudflare.com/cdn-cgi/trace | grep '^ip=' | cut -d= -f2)
[ -z "$ip" ] && ip=$(curl -s https://api.ipify.org)
if [[ ! $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Failed to detect valid IPv4 address."
    exit 1
fi

# ========== AUTH HEADER ==========
if [[ "$auth_method" == "global" ]]; then
  auth_header="X-Auth-Key: $auth_key"
else
  auth_header="Authorization: Bearer $auth_key"
fi

# ========== LOOKUP RECORD ==========
record=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?type=A&name=$record_name" \
        -H "X-Auth-Email: $auth_email" \
        -H "$auth_header" \
        -H "Content-Type: application/json")

if [[ $record == *"\"count\":0"* ]]; then
  echo "DNS record for $record_name not found. Please create it manually first."
  exit 1
fi

old_ip=$(echo "$record" | grep -oP '"content":"\K[0-9.]+')
record_identifier=$(echo "$record" | grep -oP '"id":"\K[^"]+')

# ========== UPDATE IF NEEDED ==========
if [ "$ip" == "$old_ip" ]; then
    echo "No change: $record_name already points to $ip"
    exit 0
fi

update=$(curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" \
    -H "X-Auth-Email: $auth_email" \
    -H "$auth_header" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$ip\",\"ttl\":$ttl,\"proxied\":$proxy}")

if [[ $update == *"\"success\":true"* ]]; then
    echo "Updated $sitename ($record_name) to $ip"
    exit 0
else
    echo "Failed to update $record_name. Response:"
    echo "$update"
    exit 1
fi