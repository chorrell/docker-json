FROM node:12-alpine

RUN set -ex \
    && npm install -g json

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["--version"]
