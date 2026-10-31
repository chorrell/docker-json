# syntax=docker/dockerfile:1

# Build stage - install dependencies
FROM node:lts-alpine3.23 AS builder

ARG MAJOR_VERSION=11

RUN set -ex \
    && npm install -g json@^$MAJOR_VERSION.0.0

# Minimal runtime stage - use alpine base and copy only Node binary
FROM alpine:3.24.2

LABEL org.opencontainers.image.source=https://github.com/chorrell/docker-json

# Install the shared libraries node links against (libstdc++ pulls in libgcc;
# the linux/amd64 node binary also links libatomic, arm64 doesn't need it).
# Not version-pinned: the alpine tag pins the release, and Alpine drops old
# package revisions, so exact pins would break the build.
# hadolint ignore=DL3018
RUN set -ex \
    && apk add --no-cache libstdc++ libatomic

# Copy only the Node binary from builder
COPY --from=builder /usr/local/bin/node /usr/local/bin/node

# Copy only the json package (no dependencies)
COPY --from=builder /usr/local/lib/node_modules/json /usr/local/lib/node_modules/json

# Use node to run json.js directly
ENTRYPOINT ["/usr/local/bin/node", "/usr/local/lib/node_modules/json/lib/json.js"]

CMD ["--version"]
