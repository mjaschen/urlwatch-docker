#!/usr/bin/env sh

crontab -u $APP_USER ./crontabfile
crond -f -l 6
