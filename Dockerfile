FROM alpine:3.17 as builder

ENV PATH="/opt/venv/bin:${PATH}"

RUN set -xe \
    && apk add --no-cache ca-certificates \
                          build-base      \
                          cargo           \
                          libffi-dev      \
                          libxml2         \
                          libxml2-dev     \
                          libxslt         \
                          libxslt-dev     \
                          openssl-dev     \
                          python3         \
                          python3-dev     \
                          py-pip          \
                          rust            \
    && python3 -m venv --copies /opt/venv \
    && python3 -m pip install --upgrade pip wheel \
    && python3 -m pip install appdirs   \
                              chump     \
                              cssselect \
                              html2text \
                              keyring   \
                              lxml      \
                              minidb    \
                              pyyaml    \
                              requests  \
                              urlwatch

FROM python:3.10-alpine3.17 as deploy

ENV APP_USER urlwatch

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:${PATH}"

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
