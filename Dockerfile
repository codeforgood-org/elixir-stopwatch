# Multi-stage Dockerfile for Elixir Stopwatch

# Build stage
FROM hexpm/elixir:1.16.0-erlang-26.2.1-alpine-3.19.0 AS builder

# Install build dependencies
RUN apk add --no-cache build-base git

# Create app directory
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix files
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get --only prod && \
    mix deps.compile

# Copy application files
COPY lib ./lib
COPY test ./test
COPY .formatter.exs .credo.exs ./

# Build escript
RUN MIX_ENV=prod mix escript.build

# Runtime stage
FROM alpine:3.19

# Install runtime dependencies
RUN apk add --no-cache ncurses-libs libstdc++

# Create app directory
WORKDIR /app

# Copy escript from builder
COPY --from=builder /app/stopwatch ./

# Make escript executable
RUN chmod +x stopwatch

# Run the stopwatch
ENTRYPOINT ["./stopwatch"]
