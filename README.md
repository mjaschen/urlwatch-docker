## Setup

1. add URLs to `data/urls.yaml` (see `data/urls.example.yaml` for two simple examples or take a look at the [Jobs section](https://urlwatch.readthedocs.io/en/latest/jobs.html) in the *urlwatch* documentation for all details)
1. copy `data/urlwatch.template.yaml` to `data/urlwatch.yaml` and configure at least one reporter (e.g. SMTP account details)
1. run *urlwatch*:

```shell
docker-compose up -d

# watch log output
docker-compose logs -f

# stop urlwatch
docker-compose down
```

### Change *cron* interval

*urlwatch* runs once every 15 minutes with the provided default settings. It's possible to adjust that interval by editing the provided `crontab` file and mount in into the container.

For running every hour instead of the default 15 minutes, change `crontab` as following:

```crontab
0 * * * * cd /data/urlwatch && urlwatch --verbose --urls urls.yaml --config urlwatch.yaml --hooks hooks.py --cache cache.db
```

Mount `crontab` into the container:

```shell
docker-compose run --rm --volume "$(pwd)/crontab:/var/spool/cron/crontabs/urlwatch" --volume "$(pwd):/data" --volume /etc/localtime:/etc/localtime:ro urlwatch
```

or add the mount to `docker-compose.yml`:

```yaml
version: '3'

networks:
    urlwatch:

services:
  urlwatch:
    image: ghcr.io/mjaschen/urlwatch
    volumes:
      - ./crontab:/var/spool/cron/crontabs/urlwatch:ro
      - ./data:/data/urlwatch
      - /etc/localtime:/etc/localtime:ro
    restart: "unless-stopped"
    networks:
      - urlwatch
```

## Build Locally

- clone repository: `git clone git@github.com:mjaschen/urlwatch-docker.git`
- adjust interval in crontab if needed (urlwatch is started every 15 minutes with the provided default)
- build the image and run *urlwatch*
