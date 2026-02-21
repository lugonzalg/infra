#!/bin/sh

token="$(cat /conf/hetzner-dns-token)"

domain_name="$( echo $CERTBOT_DOMAIN | rev | cut -d'.' -f 1,2 | rev)"
subdomain=".${CERTBOT_DOMAIN%.$domain_name}"
if [ "$CERTBOT_DOMAIN" = "$domain_name" ]; then
  subdomain=""
fi

ZONE_ID=$(curl -s -H "Authorization: Bearer ${token}" "https://api.hetzner.cloud/v1/zones" | jq -r ".zones[] | select(.name==\"$domain_name\") | .id")

if [ -z "$ZONE_ID" ] || [ "$ZONE_ID" = "null" ]; then
    echo "Error: No se encontró el ID de la zona para $domain_name"
    exit 1
fi

# Create TXT record for DNS-01 challenge
curl "https://api.hetzner.cloud/v1/zones/${ZONE_ID}/rrsets" \
  -X POST \
  -H "Authorization: Bearer ${token}" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"_acme-challenge${subdomain}\",
    \"type\": \"TXT\",
    \"ttl\":300,
    \"records\":[{\"value\":\"\\\"${CERTBOT_VALIDATION}\\\"\"}] }" > /dev/null 2>/dev/null

# just make sure we sleep for a while (this should be a dig poll loop)
sleep 30
