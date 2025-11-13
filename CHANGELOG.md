# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
