# syntax=docker/dockerfile:1

# Build stage - install dependencies
FROM node:lts-alpine3.23 AS builder

ARG MAJOR_VERSION=11

RUN set -ex \
    && npm install -g json@^$MAJOR_VERSION.0.0

# Minimal runtime stage - use alpine base and copy only Node binary
FROM alpine:3.23

LABEL org.opencontainers.image.source=https://github.com/chorrell/docker-json

# Copy only the Node binary and essential libraries from builder
COPY --from=builder /usr/local/bin/node /usr/local/bin/node
COPY --from=builder /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=builder /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1

# Copy only the json package (no dependencies)
COPY --from=builder /usr/local/lib/node_modules/json /usr/local/lib/node_modules/json

# Use node to run json.js directly
ENTRYPOINT ["/usr/local/bin/node", "/usr/local/lib/node_modules/json/lib/json.js"]

CMD ["--version"]
