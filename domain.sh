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
        domains+=("$domain")
        servers+=("--nginx --register-unsafely-without-email -d $domain -d $server_name")
    fi
done


for server_name in "${servers[@]}"; do
    expect certbot.exp $server_name
done

if [[ $(service cron status) == "cron is running." ]]; then
    echo $(service cron status)
else
    service cron start
    echo $(service cron status)
fi

if [[ $(service nginx status) == "nginx is running." ]]; then
#    nginx -s stop
    echo $(service nginx status)
else
#    nginx -s reload
    echo $(service nginx status)
fi