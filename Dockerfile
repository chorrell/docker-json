# syntax=docker.io/docker/dockerfile:1.4.0
FROM node:19-alpine3.17

LABEL org.opencontainers.image.source https://github.com/chorrell/docker-json

ARG MAJOR_VERSION=11

RUN set -ex \
    && npm install -g json@^$MAJOR_VERSION.0.0

COPY --link docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["--version"]
