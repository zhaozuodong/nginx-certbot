#!/bin/bash

wait

service cron start

cron_status=$(service cron status)

echo "cron status：$cron_status"

nginx_process=$(ps aux | grep -v grep | grep nginx)

if [ -z "$nginx_process" ]; then
    echo "nginx is not running."
else
    # 停止Nginx服务
    sudo nginx -s stop
    echo "nginx stopped successfully."
fi
