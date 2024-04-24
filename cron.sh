#!/bin/bash

wait

# 启动cron服务
service cron start

# 检查cron服务是否成功启动
cron_status=$(service cron status)

# 输出cron服务状态
echo "Cron 服务状态：$cron_status"
