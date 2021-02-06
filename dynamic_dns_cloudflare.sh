#!/bin/sh
domain="MY_DOMAIN_NAME"
email="CLOUDFLARE_EMAIL"
global_api_key="GLOBAL_API_KEY"
zone_id="ZONE_ID_FOR_DOMAIN"
ip_file="/var/log/dyndns.log"

ipOld=$(cat $ip_file)
ipNow=$(host myip.opendns.com resolver1.opendns.com | awk 'END {print $NF}')

echo "OLD IP Address : "$ipOld
echo "NEW IP Address : "$ipNow

if [ $ipOld != $ipNow ]; then

 domainId=$(curl -X GET "https://api.cloudflare.com/client/v4/zones/"$zone_id"/dns_records?type=A&name="$domain \
  -H "X-Auth-Email: "$email \
  -H "X-Auth-Key: "$global_api_key \
  -H "Content-Type: application/json" \
  | jq .result[0].id | tr -d '"')
  
 url="https://api.cloudflare.com/client/v4/zones/"$zone_id"/dns_records/"$domainId
 curl -X PUT $url \
  -H "X-Auth-Email: "$email \
  -H "X-Auth-Key: "$global_api_key \
  -H "Content-Type: application/json" \
  --data '{"type":"A","name":'\"$domain\"',"content":'\"$ipNow\"',"ttl":1,"proxied":false}' 
  
 echo $ipNow > $ip_file
 
else
 echo "IP Address is already up to date"
fi