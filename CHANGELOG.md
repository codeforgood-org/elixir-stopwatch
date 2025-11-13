# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Export Functionality** via `Stopwatch.Export` module
  - JSON export with full statistics and formatted times
  - CSV export for laps and event history
  - File I/O operations for saving exports
- **Configuration System** via `Stopwatch.Config` module
  - Load/save configuration from `.stopwatch.config.json`
  - Customizable default settings
  - Support for format preferences and behavior options
- **Session Persistence**
  - Save current stopwatch session to file
  - Load previously saved sessions (basic implementation)
  - Export commands in CLI (`export`, `save`, `load`)
- **Docker Support**
  - Multi-stage Dockerfile for minimal production images
  - Docker Compose configuration with dev and prod services
  - `.dockerignore` for optimized builds
  - Comprehensive Docker documentation
- **CI/CD Infrastructure**
  - GitHub Actions workflows for testing across multiple Elixir/OTP versions
  - Automated code quality checks (formatting, Credo, Dialyzer)
  - Automated escript builds
  - Release workflow with multi-platform support
  - Hex.pm publishing automation
- **Code Quality Tools**
  - Credo integration with comprehensive ruleset (`.credo.exs`)
  - Dialyzer static analysis with PLT caching
  - ExCoveralls for test coverage reporting
  - Code formatting configuration (`.formatter.exs`)
- **Developer Experience**
  - Makefile with common development commands
  - Benchmarking suite (`bench/stopwatch_bench.exs`)
  - Example scripts (`examples/basic_usage.exs`, `examples/export_example.exs`)
  - Performance benchmarks for all major operations
- **GitHub Templates**
  - Bug report template (YAML format)
  - Feature request template (YAML format)
  - Pull request template with checklist
- **Enhanced Documentation**
  - Complete API documentation (`docs/API.md`)
  - Docker usage guide (`docs/DOCKER.md`)
  - Updated README with all new features
  - Inline examples and usage patterns
- **Additional Dependencies**
  - Jason for JSON encoding/decoding
  - Credo for code quality
  - Dialyxir for static analysis
  - ExCoveralls for coverage reporting

### Changed
- Updated `mix.exs` with additional dependencies and configuration
- Enhanced `.gitignore` with more comprehensive exclusions
- Expanded CLI commands to include `export`, `save`, and `load`
- Updated README with comprehensive feature list and examples
- Improved documentation structure and organization

## [1.0.0] - 2025-11-13

### Added
- Complete rewrite and reorganization of the project structure
- Proper Mix project configuration with `mix.exs`
- Core `Stopwatch` module with comprehensive state management
  - Start/stop functionality
  - Pause/resume capability
  - Lap timing with cumulative tracking
  - Event history tracking
  - High-precision timing using monotonic time
- `Stopwatch.Formatter` module for flexible time display
  - Multiple format options: short, long, compact, verbose
  - Lap table formatting
  - Time component breakdown utilities
- `Stopwatch.CLI` module with rich interactive interface
  - Color-coded status indicators
  - Real-time elapsed time display
  - Lap statistics (fastest, slowest, average)
  - User-friendly command system
- Comprehensive test suite
  - Core stopwatch functionality tests
  - Formatter tests with multiple scenarios
  - Test coverage for all major features
- Documentation
  - Detailed README with examples and usage guide
  - Inline documentation with @doc and @moduledoc
  - Type specifications for better IDE support
  - CHANGELOG for version tracking
  - CONTRIBUTING guidelines
- Project infrastructure
  - Proper `.gitignore` for Mix projects
  - MIT License
  - Escript configuration for standalone executable

### Changed
- Migrated from simple script (`stopwatch.exs`) to full Mix project structure
- Improved time accuracy using monotonic time instead of system time
- Enhanced user experience with better formatting and colors

### Technical Details
- Minimum Elixir version: 1.14
- Uses system monotonic time for accuracy
- Modular architecture with separation of concerns
- Functional programming patterns throughout
- Comprehensive error handling with tagged tuples

## [0.1.0] - 2025-11-13 (Initial Version)

### Added
- Initial simple stopwatch script
- Basic start/stop functionality
- Simple command-line interface
- Time display in seconds

---

## Release Notes

### v1.0.0 - Major Enhancement Release

This release represents a complete overhaul of the Elixir Stopwatch project, transforming it from a simple script into a professional, feature-rich application with a proper project structure.

**Highlights:**
- Full Mix project with proper dependency management
- Comprehensive test coverage ensuring reliability
- Multiple time formatting options for different use cases
- Pause/resume functionality for flexible timing
- Lap timing with detailed statistics
- Beautiful, color-coded CLI interface
- Complete documentation and examples

**Migration Notes:**
If upgrading from the original script version (0.1.0), you'll need to:
1. Run `mix deps.get` to install dependencies
2. Build the escript with `mix escript.build`
3. Use `./stopwatch` to run the application

**Breaking Changes:**
- The application now requires a proper Mix project setup
- Direct script execution is replaced with escript binary
- API has been completely redesigned (for programmatic use)

**Future Plans:**
- Add configuration file support
- Implement named timers
- Add export functionality (CSV, JSON)
- Create a web interface option
- Add sound alerts for lap/stop events
