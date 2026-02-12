# AGENTS.md

## Project Overview

This Docker image project packages the [json](http://trentm.com/json/) npm tool
as a minimal container. The project primarily uses a multi-stage Dockerfile
with Node.js Alpine.

## Build Commands

### Build the Docker Image

```bash
docker build -t json .
```

Build with a specific version:

```bash
docker build --build-arg MAJOR_VERSION=11 -t json .
```

### Run the Image

```bash
# Version check
docker run -i --rm json --version

# Process JSON from stdin
cat test.json | docker run -i --rm json -ag name value

# Grouping
echo '{"a":1}
{"b": 2}' | docker run -i --rm json -g

# Itemizing
echo '[{"name":"trent","age":38},
     {"name":"ewan","age":4}]' | docker run -i --rm json -a name age
```

### Test Commands

Run the test suite (defined in the GitHub Actions workflow):

```bash
# Build and test locally
docker build -t json . && cat test.json | docker run -i --rm json -ag name value
```

To test with Docker Compose (if you add a compose file):

```bash
docker compose build && cat test.json | docker compose run --rm json -ag name value
```

### Running a Single Test

Since this is a simple Docker project without a test framework, single "test"
execution is done by running the container with specific arguments:

```bash
# Test specific JSON processing
echo '{"name":"test","value":123}' | docker run -i --rm json name value
```

## Code Style Guidelines

### Markdown Linting

All markdown files must pass markdownlint before being committed. Run with:

```bash
npx markdownlint-cli2 <file>
```

### Dockerfile Best Practices

- Use specific version tags for base images (e.g., `node:lts-alpine3.23`, `alpine:3.23`)
- Use multi-stage builds to minimize final image size
- Use `--no-cache` flag when appropriate to reduce layer size
- Place frequently changed layers at the bottom of the Dockerfile
- Use `LABEL` for metadata (e.g., `org.opencontainers.image.source`)
- Always use `RUN set -ex` for proper error handling in RUN commands

### Image Conventions

- Use Alpine-based images for minimal footprint
- Multi-architecture support: build for `linux/amd64` and `linux/arm64`
- Set appropriate GitHub Actions environment variables for versioning
- Include provenance and SBOM generation for security

### Naming Conventions

- Image names: lowercase, hyphenated (e.g., `json`, `docker-json`)
- Tags: use semantic versioning (e.g., `11`, `latest`)
- GitHub Actions workflow names: descriptive, lowercase with hyphens

### Error Handling

- Always use `set -ex` in shell RUN commands to fail on errors
- Use `--rm` flag with `docker run` to auto-cleanup containers
- Handle errors in shell scripts with `|| exit 1` or `set -e`

### GitHub Actions Workflows

- Use `needs:` to ensure test job passes before push
- Use concurrency groups to prevent duplicate runs
- Use OIDC for authentication when possible
- Enable build provenance: `provenance: mode=max`
- Enable SBOM generation: `sbom: true`

### Version Management

- Maintain version in one place: `MAJOR_VERSION` env var in workflow
- Use build args to pass version to Dockerfile:
  `--build-arg MAJOR_VERSION=${{ env.MAJOR_VERSION }}`
- Update version in these locations:
  - `.github/workflows/docker-publish.yml` (MAJOR_VERSION env var)
  - Dockerfile (ARG default)

## Project Structure

```text
.
├── Dockerfile              # Multi-stage Docker build
├── test.json              # Test fixture for CI
├── README.md              # Documentation
├── .github/
│   ├── workflows/
│   │   └── docker-publish.yml    # CI/CD pipeline
│   ├── dependabot.yml           # Dependency updates
│   └── CODEOWNERS               # Repository ownership
└── AGENTS.md             # This file
```

## CI/CD Pipeline

The GitHub Actions workflow (`docker-publish.yml`):

1. **Test job**: Builds image and runs test against `test.json`
2. **Push job**: Runs after test passes, pushes to Docker Hub and GHCR

### Workflow Environment Variables

| Variable      | Value | Description                          |
|---------------|-------|--------------------------------------|
| IMAGE_NAME    | json  | Image name                           |
| MAJOR_VERSION | 11    | Major version for json package       |

## Security Considerations

- Enable container vulnerability scanning
- Use specific image tags, avoid `latest` in production
- Regularly update base images via Dependabot
- Generate and store SBOM artifacts
- Use signed images when possible

## Common Tasks

### Update Node.js Version

1. Update `MAJOR_VERSION` in `.github/workflows/docker-publish.yml`
2. Update base image tags in Dockerfile (e.g., `node:lts-alpine3.23` -> `node:lts-alpine3.24`)
3. Update Alpine version if needed

### Add New JSON Test Case

Edit `test.json` with the new test data, then verify:

```bash
docker build -t json . && cat test.json | docker run -i --rm json <your-test-args>
```

### Debug Container Issues

```bash
# Run container interactively
docker run -it --rm json /bin/sh

# Inspect layers
docker history json

# View labels
docker inspect json --format='{{json .Config.Labels}}'
```
