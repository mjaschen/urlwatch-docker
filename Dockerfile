FROM alpine:3.18

RUN apk add --no-cache \
            urlwatch --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
    && rm -rf /lib/apk/db/*

ENV APP_USER urlwatch

RUN addgroup $APP_USER
RUN adduser -D -G $APP_USER $APP_USER

RUN mkdir -p /data/urlwatch \
  && chown -R $APP_USER:$APP_USER /data/urlwatch \
  && chmod 0755 /data/urlwatch

VOLUME /data/urlwatch

COPY crontabfile ./crontabfile
COPY run.sh ./run.sh

RUN rm /var/spool/cron/crontabs/root

CMD ["/bin/sh", "run.sh"]
