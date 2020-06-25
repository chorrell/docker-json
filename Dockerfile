FROM node:14-alpine

RUN set -ex \
    && npm install -g json

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["--version"]
