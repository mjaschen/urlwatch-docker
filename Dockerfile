FROM alpine

ENV APP_USER urlwatch

RUN set -xe \
    && apk add --no-cache ca-certificates \
                          build-base      \
                          libffi-dev      \
                          libxml2         \
                          libxml2-dev     \
                          libxslt         \
                          libxslt-dev     \
                          openssl-dev     \
                          python3         \
                          python3-dev     \
                          py-pip          \
    && python3 -m pip install appdirs   \
                              cssselect \
                              keyring   \
                              lxml      \
                              minidb    \
                              pyyaml    \
                              requests  \
                              chump     \
                              urlwatch  \
    && apk del build-base  \
               libffi-dev  \
               libxml2-dev \
               libxslt-dev \
               openssl-dev \
               python3-dev

RUN addgroup $APP_USER
RUN adduser -D -G $APP_USER $APP_USER

RUN mkdir -p /data/urlwatch \
  && chown -R $APP_USER:$APP_USER /data/urlwatch \
  && chmod 0755 /data/urlwatch

VOLUME /data/urlwatch

WORKDIR /data/urlwatch

COPY crontab /var/spool/cron/crontabs/$APP_USER
RUN chmod 0600 /var/spool/cron/crontabs/$APP_USER

CMD ["crond", "-f", "-l", "6", "-L", "/dev/stdout"]
