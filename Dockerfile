# syntax=docker/dockerfile:1

# Stage 1: Install json package and extract entry point
FROM node:22-alpine AS extractor

ARG MAJOR_VERSION=11

WORKDIR /build

RUN set -ex \
    && npm install --no-save json@^$MAJOR_VERSION.0.0 \
    && cp node_modules/json/lib/json.js ./json.js

# Stage 2: Generate SEA executable (requires Node.js 25.5.0+ for --build-sea)
FROM node:25-alpine AS sea-builder

WORKDIR /build

# Copy the json.js from extractor
COPY --from=extractor /build/json.js ./json.js

# Create sea-config.json for single executable generation
RUN set -ex \
    && printf '{"main":"/build/json.js","output":"/build/json-sea","executable":"/usr/local/bin/node","disableExperimentalSEAWarning":true,"useCodeCache":true}' > sea-config.json

# Generate the single executable application
RUN set -ex \
    && node --build-sea sea-config.json

# Minimal runtime stage - copy only the SEA executable
FROM alpine:3.23

LABEL org.opencontainers.image.source=https://github.com/chorrell/docker-json

# Install C++ runtime libraries required by the SEA executable
RUN set -ex \
    && apk add --no-cache libstdc++ libgcc

WORKDIR /usr/local/bin

# Copy only the single executable application from sea-builder
COPY --from=sea-builder /build/json-sea ./json

# Make it executable and set as entrypoint
RUN chmod +x ./json

ENTRYPOINT ["./json"]

CMD ["--version"]
