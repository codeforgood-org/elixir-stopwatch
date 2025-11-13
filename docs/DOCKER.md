# Docker Guide

Run Elixir Stopwatch in Docker containers for isolated, reproducible environments.

## Quick Start

### Build and Run

```bash
# Build the image
docker build -t elixir-stopwatch:latest .

# Run interactively
docker run -it --rm elixir-stopwatch:latest
```

### Using Docker Compose

```bash
# Run production build
docker-compose up stopwatch

# Run development version with live code
docker-compose up stopwatch-dev
```

## Dockerfile Details

The project uses a multi-stage build for optimal image size:

1. **Builder stage**: Compiles the Elixir application and builds the escript
2. **Runtime stage**: Minimal Alpine image with only the compiled escript

### Image Sizes

- Builder stage: ~400MB
- Final runtime image: ~20MB

## Docker Compose Services

### Production Service (`stopwatch`)

Uses the multi-stage Dockerfile to create a minimal production image.

```yaml
services:
  stopwatch:
    build: .
    image: elixir-stopwatch:latest
    stdin_open: true
    tty: true
    volumes:
      - ./exports:/app/exports
```

**Features:**
- Minimal Alpine-based image
- Compiled escript for fast startup
- Volume mount for exports

**Usage:**
```bash
docker-compose up stopwatch
```

### Development Service (`stopwatch-dev`)

Uses the full Elixir image with live code mounting.

```yaml
services:
  stopwatch-dev:
    image: hexpm/elixir:1.16.0-erlang-26.2.1-alpine-3.19.0
    volumes:
      - .:/app
      - deps:/app/deps
      - build:/app/_build
```

**Features:**
- Full Elixir development environment
- Live code mounting (changes reflected immediately)
- Persistent dependency and build caches

**Usage:**
```bash
docker-compose up stopwatch-dev
```

## Volume Mounts

### Exports Directory

Mount a local directory to save exported files:

```bash
docker run -it --rm \
  -v $(pwd)/exports:/app/exports \
  elixir-stopwatch:latest
```

Files exported from the stopwatch will be saved to `./exports` on your host machine.

## Environment Variables

Configure the stopwatch behavior with environment variables:

```bash
docker run -it --rm \
  -e TERM=xterm-256color \
  elixir-stopwatch:latest
```

Available variables:
- `TERM`: Terminal type for color support
- `MIX_ENV`: Environment (dev, test, prod)

## Building for Different Platforms

### Multi-architecture Builds

Build for multiple platforms using Docker Buildx:

```bash
# Create a builder
docker buildx create --name multiarch --use

# Build for multiple platforms
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t elixir-stopwatch:latest \
  --push \
  .
```

### Platform-specific Builds

```bash
# For ARM64 (Apple Silicon, Raspberry Pi)
docker build --platform linux/arm64 -t elixir-stopwatch:arm64 .

# For AMD64 (Intel/AMD)
docker build --platform linux/amd64 -t elixir-stopwatch:amd64 .
```

## Running Tests in Docker

```bash
# Run tests
docker run --rm \
  -v $(pwd):/app \
  -w /app \
  hexpm/elixir:1.16.0-erlang-26.2.1-alpine-3.19.0 \
  sh -c "mix deps.get && mix test"

# Run with coverage
docker run --rm \
  -v $(pwd):/app \
  -w /app \
  hexpm/elixir:1.16.0-erlang-26.2.1-alpine-3.19.0 \
  sh -c "mix deps.get && mix test --cover"
```

## Development Workflow

### Interactive Development Shell

```bash
docker run -it --rm \
  -v $(pwd):/app \
  -w /app \
  hexpm/elixir:1.16.0-erlang-26.2.1-alpine-3.19.0 \
  sh
```

Then inside the container:
```bash
mix deps.get
mix compile
mix test
iex -S mix
```

### Running Benchmarks

```bash
docker run --rm \
  -v $(pwd):/app \
  -w /app \
  hexpm/elixir:1.16.0-erlang-26.2.1-alpine-3.19.0 \
  sh -c "mix deps.get && mix run bench/stopwatch_bench.exs"
```

## Troubleshooting

### Color Support Issues

If colors aren't displaying correctly:

```bash
docker run -it --rm \
  -e TERM=xterm-256color \
  elixir-stopwatch:latest
```

### Permission Issues with Exports

If you encounter permission issues with exported files:

```bash
# Run with user ID
docker run -it --rm \
  -u $(id -u):$(id -g) \
  -v $(pwd)/exports:/app/exports \
  elixir-stopwatch:latest
```

### Build Cache Issues

Clear build cache and rebuild:

```bash
docker build --no-cache -t elixir-stopwatch:latest .
```

## Production Deployment

### Docker Registry

Push to a registry for deployment:

```bash
# Tag for registry
docker tag elixir-stopwatch:latest registry.example.com/elixir-stopwatch:latest

# Push
docker push registry.example.com/elixir-stopwatch:latest

# Pull and run on server
docker pull registry.example.com/elixir-stopwatch:latest
docker run -it --rm registry.example.com/elixir-stopwatch:latest
```

### Kubernetes Deployment

Example Kubernetes deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: stopwatch
spec:
  replicas: 1
  selector:
    matchLabels:
      app: stopwatch
  template:
    metadata:
      labels:
        app: stopwatch
    spec:
      containers:
      - name: stopwatch
        image: elixir-stopwatch:latest
        stdin: true
        tty: true
        volumeMounts:
        - name: exports
          mountPath: /app/exports
      volumes:
      - name: exports
        emptyDir: {}
```

## Best Practices

1. **Use specific tags**: Instead of `latest`, use version tags for reproducibility
2. **Minimize layers**: Combine RUN commands to reduce image size
3. **Use .dockerignore**: Exclude unnecessary files from build context
4. **Multi-stage builds**: Keep final image small
5. **Security scanning**: Regularly scan images for vulnerabilities

```bash
# Scan for vulnerabilities
docker scan elixir-stopwatch:latest
```

## Resources

- [Official Elixir Docker Images](https://hub.docker.com/r/hexpm/elixir)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)
