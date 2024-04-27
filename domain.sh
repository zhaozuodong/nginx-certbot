#!/bin/bash
config_path='/etc/nginx/conf.d/*'

domains=()
servers=()

lines=$(grep -oh 'server_name[^;]*' $config_path | sed 's/server_name//g' | tr '\t' '\n' | tr ' ' '\n' | grep -v '^$' | sort | uniq)
IFS=$'\n'
read -d '' -ra parts <<< "$lines"

for server_name in "${parts[@]}"; do
    domain=$(echo "$server_name" | awk -F'.' '{print $(NF-1)"."$NF}')
    found=0
    for dm in "${!domains[@]}"; do
        if [ "${domains[$dm]}" == "$domain" ]; then
            found=1
            if [ "$server_name" != "$domain" ]; then
                servers[$dm]="${servers[$dm]} -d $server_name"
            fi
            break
        fi
    done
    if [ $found -eq 0 ]; then
        if echo "$domain" | grep -E -q 'localhost|127\.0\.0\.1|192\.168\.|10\.|172\.(1[6-9]|2[0-9]|3[01])\.|127\.|^$'; then
            echo "domain contains localhost or 127.0.0.1"
        else
            domains+=("$domain")
            servers+=("--nginx --register-unsafely-without-email -d $domain -d $server_name")
        fi
    fi
done


for server_name in "${servers[@]}"; do
    expect certbot.exp $server_name
done

service cron start
echo $(service cron status)
