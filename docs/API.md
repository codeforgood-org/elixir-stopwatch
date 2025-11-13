# API Documentation

Complete API reference for the Stopwatch module and its submodules.

## Table of Contents

- [Stopwatch](#stopwatch)
- [Stopwatch.Formatter](#stopwatchformatter)
- [Stopwatch.Export](#stopwatchexport)
- [Stopwatch.Config](#stopwatchconfig)
- [Stopwatch.CLI](#stopwatchcli)

## Stopwatch

The main stopwatch module providing timing functionality.

### Types

```elixir
@type state :: :stopped | :running | :paused
@type t :: %Stopwatch{}
```

### Functions

#### `new/0`

Creates a new stopwatch instance in the stopped state.

```elixir
stopwatch = Stopwatch.new()
```

#### `start/1`

Starts the stopwatch.

```elixir
{:ok, stopwatch} = Stopwatch.start(stopwatch)
```

Returns `{:ok, stopwatch}` or `{:error, reason}`.

#### `stop/1`

Stops the stopwatch and returns the total elapsed time.

```elixir
{:ok, stopwatch, elapsed_ms} = Stopwatch.stop(stopwatch)
```

#### `pause/1`

Pauses a running stopwatch.

```elixir
{:ok, stopwatch} = Stopwatch.pause(stopwatch)
```

#### `resume/1`

Resumes a paused stopwatch.

```elixir
{:ok, stopwatch} = Stopwatch.resume(stopwatch)
```

#### `lap/1`

Records a lap time.

```elixir
{:ok, stopwatch, lap_time_ms} = Stopwatch.lap(stopwatch)
```

#### `elapsed/1`

Returns the current elapsed time in milliseconds.

```elixir
elapsed_ms = Stopwatch.elapsed(stopwatch)
```

#### `get_laps/1`

Returns all recorded lap times in chronological order.

```elixir
laps = Stopwatch.get_laps(stopwatch)
```

#### `get_history/1`

Returns the complete history of all stopwatch events.

```elixir
history = Stopwatch.get_history(stopwatch)
```

#### `reset/1`

Resets the stopwatch to initial state.

```elixir
stopwatch = Stopwatch.reset(stopwatch)
```

## Stopwatch.Formatter

Provides various time formatting options.

### Functions

#### `format/2`

Formats milliseconds into a human-readable time string.

```elixir
# Short format (default)
Stopwatch.Formatter.format(125432)
# => "02:05.432"

# Long format
Stopwatch.Formatter.format(125432, :long)
# => "00:02:05.432"

# Compact format
Stopwatch.Formatter.format(125432, :compact)
# => "2m 5.432s"

# Verbose format
Stopwatch.Formatter.format(125432, :verbose)
# => "432 milliseconds, 5 seconds, 2 minutes"
```

#### `format_seconds/1`

Formats milliseconds as decimal seconds.

```elixir
Stopwatch.Formatter.format_seconds(5432)
# => "5.432"
```

#### `breakdown/1`

Breaks down milliseconds into components.

```elixir
{hours, minutes, seconds, ms} = Stopwatch.Formatter.breakdown(3661234)
# => {1, 1, 1, 234}
```

## Stopwatch.Export

Export stopwatch data to various formats.

### Functions

#### `to_json/1`

Exports stopwatch data to JSON format.

```elixir
{:ok, json_string} = Stopwatch.Export.to_json(stopwatch)
```

#### `to_json_file/2`

Exports stopwatch data to a JSON file.

```elixir
{:ok, filename} = Stopwatch.Export.to_json_file(stopwatch, "data.json")
```

#### `laps_to_csv/1`

Exports lap data to CSV format.

```elixir
csv_string = Stopwatch.Export.laps_to_csv(stopwatch)
```

#### `laps_to_csv_file/2`

Exports lap data to a CSV file.

```elixir
{:ok, filename} = Stopwatch.Export.laps_to_csv_file(stopwatch, "laps.csv")
```

#### `history_to_csv/1`

Exports event history to CSV format.

```elixir
csv_string = Stopwatch.Export.history_to_csv(stopwatch)
```

#### `history_to_csv_file/2`

Exports event history to a CSV file.

```elixir
{:ok, filename} = Stopwatch.Export.history_to_csv_file(stopwatch, "history.csv")
```

## Stopwatch.Config

Configuration management for Stopwatch.

### Functions

#### `load/0`

Loads configuration from file or returns defaults.

```elixir
{:ok, config} = Stopwatch.Config.load()
```

#### `save/1`

Saves configuration to file.

```elixir
:ok = Stopwatch.Config.save(config)
```

#### `defaults/0`

Returns the default configuration.

```elixir
config = Stopwatch.Config.defaults()
```

#### `get/3`

Gets a specific configuration value.

```elixir
value = Stopwatch.Config.get(config, :default_format, :long)
```

#### `put/3`

Updates a configuration value.

```elixir
config = Stopwatch.Config.put(config, :default_format, :short)
```

### Default Configuration

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

## Stopwatch.CLI

Interactive command-line interface.

### Commands

- `start` - Start the stopwatch
- `stop` - Stop the stopwatch and display total time
- `pause` - Pause the stopwatch
- `resume` - Resume a paused stopwatch
- `lap` - Record a lap time
- `laps` - Display all recorded laps
- `status` - Show current stopwatch state and statistics
- `reset` - Reset the stopwatch to initial state
- `export` - Export data (JSON/CSV)
- `save` - Save current session
- `load` - Load saved session
- `help` - Show help message
- `quit`/`exit` - Exit the application

## Examples

### Basic Usage

```elixir
# Create and start
stopwatch = Stopwatch.new()
{:ok, stopwatch} = Stopwatch.start(stopwatch)

# Record laps
Process.sleep(1000)
{:ok, stopwatch, lap1} = Stopwatch.lap(stopwatch)

Process.sleep(500)
{:ok, stopwatch, lap2} = Stopwatch.lap(stopwatch)

# Pause and resume
{:ok, stopwatch} = Stopwatch.pause(stopwatch)
Process.sleep(1000)  # Time not counted
{:ok, stopwatch} = Stopwatch.resume(stopwatch)

# Stop
{:ok, stopwatch, total} = Stopwatch.stop(stopwatch)

# Format and display
formatted = Stopwatch.Formatter.format(total, :long)
IO.puts("Total time: #{formatted}")
```

### Export Data

```elixir
# Export to JSON
{:ok, json} = Stopwatch.Export.to_json(stopwatch)

# Export laps to CSV
{:ok, "laps.csv"} = Stopwatch.Export.laps_to_csv_file(stopwatch, "laps.csv")

# Export history to CSV
{:ok, "history.csv"} = Stopwatch.Export.history_to_csv_file(stopwatch, "history.csv")
```

### Statistics

```elixir
# Get all laps
laps = Stopwatch.get_laps(stopwatch)

# Calculate statistics
lap_times =
  laps
  |> Enum.chunk_every(2, 1, [0])
  |> Enum.map(fn [curr, prev] -> curr - prev end)

fastest = Enum.min(lap_times)
slowest = Enum.max(lap_times)
average = div(Enum.sum(lap_times), length(lap_times))

IO.puts("Fastest: #{Stopwatch.Formatter.format(fastest)}")
IO.puts("Slowest: #{Stopwatch.Formatter.format(slowest)}")
IO.puts("Average: #{Stopwatch.Formatter.format(average)}")
```

## Error Handling

All state-changing operations return tagged tuples:

```elixir
# Success
{:ok, stopwatch} = Stopwatch.start(stopwatch)

# Error
{:error, reason} = Stopwatch.start(already_running_stopwatch)
```

Common error scenarios:
- Starting an already running stopwatch
- Stopping a stopped stopwatch
- Pausing a non-running stopwatch
- Resuming a non-paused stopwatch
- Recording a lap while stopped
