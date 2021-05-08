FROM node:16-alpine

LABEL org.opencontainers.image.source https://github.com/chorrell/docker-json

ARG MAJOR_VERSION=10

RUN set -ex \
    && npm install -g json@^$MAJOR_VERSION.0.0

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["--version"]
