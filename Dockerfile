FROM nginx:1.23

RUN apt-get update && apt-get install -y certbot python3-certbot-nginx expect vim cron

COPY certbot_expect.sh /usr/local/bin/certbot_expect.sh
RUN chmod +x /usr/local/bin/certbot_expect.sh
RUN /usr/local/bin/certbot_expect.sh

COPY cronjob /etc/cron.d/cronjob
RUN chmod +x /etc/cron.d/certbot && chmod +x /etc/cron.d/cronjob

EXPOSE 80
EXPOSE 443

CMD certbot_expect.sh && cron -f