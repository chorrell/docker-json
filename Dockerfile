FROM node:14-alpine

RUN set -ex \
    && npm install -g json@^10.0.0

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["--version"]
