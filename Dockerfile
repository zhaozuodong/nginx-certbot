FROM nginx:1.23

RUN apt-get update && apt-get install -y certbot python3-certbot-nginx expect vim cron

COPY domain.sh /docker-entrypoint.d/01-domain.sh
COPY certbot.exp /docker-entrypoint.d/certbot.exp
RUN chmod 777 /docker-entrypoint.d/01-domain.sh && chmod 777 /docker-entrypoint.d/certbot.exp

EXPOSE 80
EXPOSE 443