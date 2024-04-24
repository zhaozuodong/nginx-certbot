FROM nginx:1.23

RUN apt-get update && apt-get install -y certbot python3-certbot-nginx expect vim cron

COPY certbot_expect.sh /usr/local/bin/certbot_expect.sh
COPY certbot_expect.sh /docker-entrypoint.d/certbot_expect.sh
COPY cron.sh /docker-entrypoint.d/cron.sh
RUN chmod 777 /usr/local/bin/certbot_expect.sh && chmod 777 /docker-entrypoint.d/certbot_expect.sh && chmod 777 /docker-entrypoint.d/cron.sh
RUN /usr/local/bin/certbot_expect.sh

COPY cronjob /etc/cron.d/cronjob
RUN chmod 777 /etc/cron.d/certbot && chmod 777 /etc/cron.d/cronjob

EXPOSE 80
EXPOSE 443