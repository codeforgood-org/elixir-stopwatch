.PHONY: help build test format check clean run install docker bench docs

# Default target
help:
	@echo "Elixir Stopwatch - Available Commands"
	@echo "======================================"
	@echo ""
	@echo "Development:"
	@echo "  make install    - Install dependencies"
	@echo "  make build      - Build the escript"
	@echo "  make run        - Run the stopwatch"
	@echo "  make test       - Run tests"
	@echo "  make bench      - Run benchmarks"
	@echo ""
	@echo "Code Quality:"
	@echo "  make format     - Format code"
	@echo "  make check      - Run all checks (format, credo, dialyzer, tests)"
	@echo "  make credo      - Run Credo linter"
	@echo "  make dialyzer   - Run Dialyzer static analysis"
	@echo ""
	@echo "Documentation:"
	@echo "  make docs       - Generate documentation"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-build - Build Docker image"
	@echo "  make docker-run   - Run in Docker container"
	@echo ""
	@echo "Utilities:"
	@echo "  make clean      - Clean build artifacts"
	@echo ""

# Install dependencies
install:
	mix local.hex --force
	mix local.rebar --force
	mix deps.get

# Build the escript
build:
	mix escript.build

# Run the stopwatch
run: build
	./stopwatch

# Run tests
test:
	mix test

# Run tests with coverage
test-coverage:
	mix coveralls.html
	@echo "Coverage report generated in cover/excoveralls.html"

# Run benchmarks
bench:
	mix run bench/stopwatch_bench.exs

# Format code
format:
	mix format

# Check code formatting
format-check:
	mix format --check-formatted

# Run Credo
credo:
	mix credo --strict

# Run Dialyzer
dialyzer:
	mix dialyzer

# Run all checks
check: format-check credo dialyzer test
	@echo "All checks passed! ✓"

# Generate documentation
docs:
	mix docs
	@echo "Documentation generated in doc/"

# Clean build artifacts
clean:
	rm -rf _build deps stopwatch doc cover
	rm -f *.ez *.beam erl_crash.dump
	rm -f stopwatch_*.json stopwatch_*.csv example_*.json example_*.csv

# Docker build
docker-build:
	docker build -t elixir-stopwatch:latest .

# Docker run
docker-run:
	docker run -it --rm elixir-stopwatch:latest

# Docker compose up
docker-up:
	docker-compose up stopwatch

# Docker compose up (dev)
docker-dev:
	docker-compose up stopwatch-dev

# Release (tag and build)
release:
	@echo "Current version: $$(grep '@version' mix.exs | cut -d'"' -f2)"
	@echo "Update version in mix.exs and CHANGELOG.md before releasing"
	@read -p "Ready to tag release? (y/N): " confirm; \
	if [ "$$confirm" = "y" ]; then \
		version=$$(grep '@version' mix.exs | cut -d'"' -f2); \
		git tag -a "v$$version" -m "Release v$$version"; \
		git push --tags; \
		echo "Tagged release v$$version"; \
	fi
