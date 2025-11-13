# Elixir Stopwatch

A feature-rich command-line stopwatch application built with Elixir, offering precise timing with lap functionality, pause/resume capabilities, and an intuitive interactive interface.

## Features

### Core Functionality
- **High-Precision Timing**: Uses system monotonic time for accurate measurements
- **Lap Timing**: Record and track multiple lap times during a run
- **Pause/Resume**: Pause the timer and resume without losing accuracy
- **Comprehensive History**: Track all timing events and actions
- **Statistics**: View fastest, slowest, and average lap times

### Display & Interface
- **Multiple Display Formats**: View times in short, long, compact, or verbose formats
- **Rich CLI Interface**: Color-coded status indicators and real-time display
- **Interactive REPL**: Easy-to-use command-line interface with intuitive commands

### Data Management
- **Export Functionality**: Export data to JSON and CSV formats
- **Session Persistence**: Save and load stopwatch sessions
- **Configuration Support**: Customizable settings via config file

### Developer Tools
- **Docker Support**: Run in containers with provided Dockerfile and docker-compose
- **CI/CD Ready**: GitHub Actions workflows for testing and releases
- **Code Quality**: Integrated Credo linting and Dialyzer type checking
- **Comprehensive Tests**: Full test suite with high coverage
- **Benchmarking**: Performance benchmarks included

## Installation

### Prerequisites

- Elixir 1.14 or higher
- Erlang/OTP 24 or higher

### Building from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/codeforgood-org/elixir-stopwatch.git
   cd elixir-stopwatch
   ```

2. Install dependencies:
   ```bash
   mix deps.get
   ```

3. Build the executable:
   ```bash
   mix escript.build
   ```

4. Run the stopwatch:
   ```bash
   ./stopwatch
   ```

### Using Make

A Makefile is provided for common tasks:

```bash
# Show all available commands
make help

# Install dependencies and build
make install
make build

# Run the stopwatch
make run

# Run tests
make test

# Run all code quality checks
make check

# Generate documentation
make docs

# Run benchmarks
make bench
```

### Using Docker

```bash
# Build and run with Docker
docker build -t elixir-stopwatch .
docker run -it --rm elixir-stopwatch

# Or use Docker Compose
docker-compose up stopwatch
```

See [docs/DOCKER.md](docs/DOCKER.md) for detailed Docker instructions.

### Running Tests

```bash
# Run all tests
make test

# Run with coverage
mix test --cover

# Run tests with coverage report
mix coveralls.html
```

### Running Benchmarks

```bash
make bench
# or
mix run bench/stopwatch_bench.exs
```

### Generating Documentation

```bash
make docs
# or
mix docs
```

Documentation will be available in `doc/index.html`.

## Usage

### Interactive Mode

Start the stopwatch application:

```bash
./stopwatch
```

Or with Elixir directly:

```bash
elixir -S mix run -e "Stopwatch.CLI.main()"
```

### Available Commands

| Command | Description |
|---------|-------------|
| `start` | Start the stopwatch |
| `stop` | Stop the stopwatch and display total time |
| `pause` | Pause the stopwatch |
| `resume` | Resume a paused stopwatch |
| `lap` | Record a lap time |
| `laps` | Display all recorded laps |
| `status` | Show current stopwatch state and statistics |
| `reset` | Reset the stopwatch to initial state |
| `export` | Export data to JSON or CSV formats |
| `save` | Save current session to file |
| `load` | Load a saved session |
| `help` | Show help message |
| `quit` or `exit` | Exit the application |

### Example Session

```
╔═══════════════════════════════════════╗
║   Elixir Stopwatch v1.0.0             ║
╚═══════════════════════════════════════╝
Type 'help' for available commands.

⏹ STOPPED
> start
✓ Stopwatch started!

▶ RUNNING | 00:00:01.234
> lap
Lap 1: 00:01.234 (Total: 00:00:01.234)

▶ RUNNING | 00:00:03.456
> lap
Lap 2: 00:02.222 (Total: 00:00:03.456)

▶ RUNNING | 00:00:05.789
> pause
⏸ Stopwatch paused at 00:00:05.789

⏸ PAUSED | 00:00:05.789
> resume
▶ Stopwatch resumed!

▶ RUNNING | 00:00:08.012
> stop

✓ Stopwatch stopped!
Total time: 00:00:08.012

Lap summary:
  Lap      Lap Time     Total Time
  ----------------------------------------
    1      00:01.234      00:01.234
    2      00:02.222      00:03.456
    3      00:04.556      00:08.012
```

### Using as a Library

You can also use the Stopwatch module programmatically in your Elixir projects:

```elixir
# Create a new stopwatch
stopwatch = Stopwatch.new()

# Start timing
{:ok, stopwatch} = Stopwatch.start(stopwatch)

# Record a lap
{:ok, stopwatch, lap_time} = Stopwatch.lap(stopwatch)

# Pause the stopwatch
{:ok, stopwatch} = Stopwatch.pause(stopwatch)

# Resume timing
{:ok, stopwatch} = Stopwatch.resume(stopwatch)

# Get elapsed time
elapsed = Stopwatch.elapsed(stopwatch)

# Stop the stopwatch
{:ok, stopwatch, total_time} = Stopwatch.stop(stopwatch)

# Format time for display
Stopwatch.Formatter.format(elapsed, :long)
# => "00:01:23.456"
```

## Time Formatting

The `Stopwatch.Formatter` module provides several formatting options:

### Short Format (default)
```elixir
Stopwatch.Formatter.format(125432, :short)
# => "02:05.432"
```

### Long Format
```elixir
Stopwatch.Formatter.format(125432, :long)
# => "00:02:05.432"
```

### Compact Format
```elixir
Stopwatch.Formatter.format(125432, :compact)
# => "2m 5.432s"
```

### Verbose Format
```elixir
Stopwatch.Formatter.format(125432, :verbose)
# => "432 milliseconds, 5 seconds, 2 minutes"
```

## Exporting Data

Export stopwatch data for analysis or record-keeping:

### JSON Export

```elixir
# Export to JSON string
{:ok, json} = Stopwatch.Export.to_json(stopwatch)

# Export to JSON file
{:ok, filename} = Stopwatch.Export.to_json_file(stopwatch, "data.json")
```

Example JSON output:
```json
{
  "state": "stopped",
  "elapsed": 5432,
  "elapsed_formatted": "00:00:05.432",
  "laps": [
    {
      "lap_number": 1,
      "lap_time_ms": 1234,
      "lap_time_formatted": "00:01.234",
      "cumulative_time_ms": 1234,
      "cumulative_time_formatted": "00:00:01.234"
    }
  ],
  "statistics": {
    "fastest_lap_ms": 1234,
    "slowest_lap_ms": 2345,
    "average_lap_ms": 1789
  }
}
```

### CSV Export

```elixir
# Export laps to CSV
csv = Stopwatch.Export.laps_to_csv(stopwatch)
{:ok, filename} = Stopwatch.Export.laps_to_csv_file(stopwatch, "laps.csv")

# Export history to CSV
history_csv = Stopwatch.Export.history_to_csv(stopwatch)
{:ok, filename} = Stopwatch.Export.history_to_csv_file(stopwatch, "history.csv")
```

## Configuration

Customize stopwatch behavior with a configuration file:

```elixir
# Load configuration
{:ok, config} = Stopwatch.Config.load()

# Update configuration
config = Stopwatch.Config.put(config, :default_format, :compact)

# Save configuration
Stopwatch.Config.save(config)
```

Default configuration options:
```elixir
%{
  default_format: :long,
  auto_save: false,
  auto_save_interval: 60_000,
  color_enabled: true,
  sound_enabled: false,
  history_limit: 1000
}
```

Configuration is stored in `.stopwatch.config.json`.

## Architecture

The project is organized into five main modules:

- **`Stopwatch`**: Core stopwatch logic with state management
- **`Stopwatch.Formatter`**: Time formatting utilities
- **`Stopwatch.Export`**: Data export functionality (JSON, CSV)
- **`Stopwatch.Config`**: Configuration management
- **`Stopwatch.CLI`**: Interactive command-line interface

### Module Documentation

#### Stopwatch

The main stopwatch module provides:
- State management (stopped, running, paused)
- High-precision timing using monotonic time
- Lap recording and tracking
- Event history
- Pause/resume with accurate time accounting

#### Stopwatch.Formatter

Formatting utilities for displaying elapsed time:
- Multiple format styles (short, long, compact, verbose)
- Time component breakdown
- Lap table formatting

#### Stopwatch.Export

Data export functionality:
- JSON export with full statistics
- CSV export for laps and history
- File I/O operations

#### Stopwatch.Config

Configuration management:
- Load/save configuration files
- Default settings
- Customizable options

#### Stopwatch.CLI

Interactive command-line interface featuring:
- Real-time status display
- Color-coded output
- Lap statistics
- Export commands
- Session save/load
- User-friendly prompts

See [docs/API.md](docs/API.md) for complete API documentation.

## Development

### Project Structure

```
elixir-stopwatch/
├── lib/
│   ├── stopwatch.ex           # Core stopwatch module
│   └── stopwatch/
│       ├── cli.ex             # CLI interface
│       └── formatter.ex       # Time formatting
├── test/
│   ├── stopwatch_test.exs     # Core tests
│   └── stopwatch/
│       └── formatter_test.exs # Formatter tests
├── mix.exs                    # Project configuration
└── README.md
```

### Running Tests

```bash
# Run all tests
mix test

# Run with coverage
mix test --cover

# Run specific test file
mix test test/stopwatch_test.exs

# Run tests matching a pattern
mix test --only lap
```

### Code Quality

```bash
# Format code
mix format

# Check for warnings
mix compile --warnings-as-errors

# Run static analysis (if using Credo)
mix credo
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please make sure to update tests as appropriate and follow the existing code style.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with [Elixir](https://elixir-lang.org/)
- Inspired by traditional command-line stopwatch utilities
- Created for educational purposes and practical use

## Support

If you encounter any issues or have questions:
- Open an issue on [GitHub](https://github.com/codeforgood-org/elixir-stopwatch/issues)
- Check the documentation: `mix docs`

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.

---

Made with ❤️ by the codeforgood-org team
