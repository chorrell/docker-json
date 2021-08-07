FROM node:16-alpine3.14

LABEL org.opencontainers.image.source https://github.com/chorrell/docker-json

ARG MAJOR_VERSION=11

RUN set -ex \
    && npm install -g json@^$MAJOR_VERSION.0.0

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["--version"]
