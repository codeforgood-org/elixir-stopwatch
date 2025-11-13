#!/usr/bin/env elixir

# Export functionality example
# Run with: elixir examples/export_example.exs

# Add the lib directory to the code path
Code.prepend_path("_build/dev/lib/stopwatch/ebin")

IO.puts("""
╔═══════════════════════════════════════╗
║   Stopwatch Export Example           ║
╚═══════════════════════════════════════╝
""")

# Create a stopwatch with some data
IO.puts("Creating stopwatch with sample data...")
{:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()

# Record several laps
Enum.each(1..5, fn i ->
  Process.sleep(100 + i * 50)
  {:ok, stopwatch, lap_time} = Stopwatch.lap(stopwatch)

  IO.puts(
    "  Lap #{i}: #{Stopwatch.Formatter.format(lap_time, :short)}"
  )

  stopwatch
end)
|> then(fn sw -> {:ok, sw, _} = Stopwatch.stop(sw); sw end)
|> tap(fn _ -> IO.puts("") end)

# Export to JSON
IO.puts("Exporting to JSON...")
{:ok, json} = Stopwatch.Export.to_json(stopwatch)
IO.puts("JSON output:")
IO.puts(json)
IO.puts("")

# Export laps to CSV
IO.puts("Exporting laps to CSV...")
csv = Stopwatch.Export.laps_to_csv(stopwatch)
IO.puts("CSV output:")
IO.puts(csv)
IO.puts("")

# Export history to CSV
IO.puts("Exporting history to CSV...")
history_csv = Stopwatch.Export.history_to_csv(stopwatch)
IO.puts("History CSV output:")
IO.puts(history_csv)
IO.puts("")

# Save to files
IO.puts("Saving to files...")
{:ok, json_file} = Stopwatch.Export.to_json_file(stopwatch, "example_export.json")
IO.puts("  Saved JSON to: #{json_file}")

{:ok, csv_file} = Stopwatch.Export.laps_to_csv_file(stopwatch, "example_laps.csv")
IO.puts("  Saved laps CSV to: #{csv_file}")

{:ok, history_file} = Stopwatch.Export.history_to_csv_file(stopwatch, "example_history.csv")
IO.puts("  Saved history CSV to: #{history_file}")

IO.puts("\nExport example complete! ✓")
IO.puts("Check the generated files in the current directory.")
