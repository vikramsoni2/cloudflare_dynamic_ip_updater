# cloudflare_dynamic_ip_updater
Handy script to automatically update your cloudflare domain A record to a dynamic IP address.   
  
It uses cloudflare API to update the IP address. This script can be run on your home server with cron and will periodically check for your public IP address. Whenever the IP address changes, it triggers the Cloudflare API call to update your IP address to your attached domain.
