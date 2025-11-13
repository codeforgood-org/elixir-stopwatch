# Elixir Stopwatch

A feature-rich command-line stopwatch application built with Elixir, offering precise timing with lap functionality, pause/resume capabilities, and an intuitive interactive interface.

## Features

- **High-Precision Timing**: Uses system monotonic time for accurate measurements
- **Lap Timing**: Record and track multiple lap times during a run
- **Pause/Resume**: Pause the timer and resume without losing accuracy
- **Multiple Display Formats**: View times in various formats (short, long, compact, verbose)
- **Rich CLI Interface**: Color-coded status indicators and real-time display
- **Comprehensive History**: Track all timing events and actions
- **Statistics**: View fastest, slowest, and average lap times
- **Interactive REPL**: Easy-to-use command-line interface

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

### Running Tests

```bash
mix test
```

### Generating Documentation

```bash
mix docs
```

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

## Architecture

The project is organized into three main modules:

- **`Stopwatch`**: Core stopwatch logic with state management
- **`Stopwatch.Formatter`**: Time formatting utilities
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
- Multiple format styles
- Time component breakdown
- Lap table formatting

#### Stopwatch.CLI

Interactive command-line interface featuring:
- Real-time status display
- Color-coded output
- Lap statistics
- User-friendly prompts

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
