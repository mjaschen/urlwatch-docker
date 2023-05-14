FROM python:3.11.3-alpine3.18 as builder

RUN apk add --no-cache \
    binutils \
    git \
    upx                 

# Update pip, wheel and setuptools, install pyinstaller
RUN python3 -m pip install --upgrade pip wheel setuptools \
    && python3 -m pip install pyinstaller

# Get latest urlwatch source
RUN git clone https://github.com/thp/urlwatch.git
WORKDIR /urlwatch

# Install requirements and urlwatch from source
RUN python3 -m pip install -r requirements.txt \
    && python3 -m pip install .

# Install additional packages used by urlwatch (optional)
# see https://urlwatch.readthedocs.io/en/latest/dependencies.html#optional-packages
RUN python3 -m pip install \
    chump \
    html2text

# Build the executable file (-F) and strip debug symbols 
# Use pythons optimize flag (-OO) to remove doc strings, assert statements, sets __debug__ to false
RUN python3 -OO -m PyInstaller -F --strip urlwatch 

# Debug: list warnings
# RUN cat build/urlwatch/warn-urlwatch.txt


FROM alpine:3.18 as deploy
ENV APP_USER urlwatch

COPY --from=builder /urlwatch/dist/urlwatch /usr/local/bin/urlwatch

RUN addgroup $APP_USER
RUN adduser -D -G $APP_USER $APP_USER

RUN mkdir -p /data/urlwatch \
  && chown -R $APP_USER:$APP_USER /data/urlwatch \
  && chmod 0755 /data/urlwatch

VOLUME /data/urlwatch

RUN rm /var/spool/cron/crontabs/root

COPY crontabfile ./crontabfile
COPY run.sh ./run.sh

CMD ["/bin/sh", "run.sh"]
