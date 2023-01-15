## Setup

- add URLs to `data/urls.yaml` (see `data/urls.example.yaml` for two simple examples or take a look at the [Jobs section](https://urlwatch.readthedocs.io/en/latest/jobs.html) in the *urlwatch* documentation for all details)
- copy `data/urlwatch.template.yaml` to `data/urlwatch.yaml` and configure at least one reporter (e.g. SMTP account details)

```shell
docker-compose up -d

# watch log output
docker-compose logs -f
```

## Build Locally

- clone repository: `git clone git@github.com:mjaschen/urlwatch-docker.git`
- adjust interval in crontab if needed (urlwatch is started every 15 minutes with the provided default)
- build the image and run *urlwatch*
