#!/usr/bin/env elixir

# Basic usage example for Stopwatch module
# Run with: elixir examples/basic_usage.exs

# Add the lib directory to the code path
Code.prepend_path("_build/dev/lib/stopwatch/ebin")

IO.puts("""
╔═══════════════════════════════════════╗
║   Stopwatch Basic Usage Example      ║
╚═══════════════════════════════════════╝
""")

# Create a new stopwatch
IO.puts("1. Creating a new stopwatch...")
stopwatch = Stopwatch.new()
IO.inspect(stopwatch.state, label: "   Initial state")
IO.puts("")

# Start the stopwatch
IO.puts("2. Starting the stopwatch...")
{:ok, stopwatch} = Stopwatch.start(stopwatch)
IO.inspect(stopwatch.state, label: "   State after start")
IO.puts("")

# Wait a bit
IO.puts("3. Waiting 1 second...")
Process.sleep(1000)
elapsed = Stopwatch.elapsed(stopwatch)
IO.puts("   Elapsed: #{Stopwatch.Formatter.format(elapsed, :long)}")
IO.puts("")

# Record a lap
IO.puts("4. Recording first lap...")
{:ok, stopwatch, lap_time} = Stopwatch.lap(stopwatch)
IO.puts("   Lap time: #{Stopwatch.Formatter.format(lap_time, :short)}")
IO.puts("")

# Wait and record another lap
IO.puts("5. Waiting 500ms and recording second lap...")
Process.sleep(500)
{:ok, stopwatch, lap_time} = Stopwatch.lap(stopwatch)
IO.puts("   Lap time: #{Stopwatch.Formatter.format(lap_time, :short)}")
IO.puts("")

# Pause the stopwatch
IO.puts("6. Pausing the stopwatch...")
{:ok, stopwatch} = Stopwatch.pause(stopwatch)
IO.inspect(stopwatch.state, label: "   State after pause")
pause_elapsed = Stopwatch.elapsed(stopwatch)
IO.puts("   Elapsed at pause: #{Stopwatch.Formatter.format(pause_elapsed, :long)}")
IO.puts("")

# Wait while paused
IO.puts("7. Waiting 1 second while paused...")
Process.sleep(1000)
still_paused = Stopwatch.elapsed(stopwatch)
IO.puts("   Elapsed (should be same): #{Stopwatch.Formatter.format(still_paused, :long)}")
IO.puts("")

# Resume the stopwatch
IO.puts("8. Resuming the stopwatch...")
{:ok, stopwatch} = Stopwatch.resume(stopwatch)
IO.inspect(stopwatch.state, label: "   State after resume")
IO.puts("")

# Wait and stop
IO.puts("9. Waiting 500ms and stopping...")
Process.sleep(500)
{:ok, stopwatch, total_time} = Stopwatch.stop(stopwatch)
IO.puts("   Total time: #{Stopwatch.Formatter.format(total_time, :long)}")
IO.puts("")

# Display all laps
IO.puts("10. All recorded laps:")
laps = Stopwatch.get_laps(stopwatch)

Enum.with_index(laps, 1)
|> Enum.reduce(0, fn {cumulative_time, index}, prev_time ->
  lap_time = cumulative_time - prev_time
  IO.puts(
    "    Lap #{index}: #{Stopwatch.Formatter.format(lap_time, :short)} " <>
      "(Total: #{Stopwatch.Formatter.format(cumulative_time, :long)})"
  )

  cumulative_time
end)

IO.puts("")

# Display history
IO.puts("11. Event history:")
history = Stopwatch.get_history(stopwatch)

Enum.each(history, fn event ->
  elapsed_str =
    if event.elapsed do
      Stopwatch.Formatter.format(event.elapsed, :long)
    else
      "N/A"
    end

  IO.puts("    #{event.action}: #{elapsed_str}")
end)

IO.puts("")
IO.puts("Example complete! ✓")
