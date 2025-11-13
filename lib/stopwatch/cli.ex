defmodule Stopwatch.CLI do
  @moduledoc """
  Command-line interface for the Stopwatch application.

  Provides an interactive REPL for controlling a stopwatch with various commands.
  """

  alias Stopwatch.Formatter

  @commands """

  Available commands:
    start          - Start the stopwatch
    stop           - Stop the stopwatch and display total time
    pause          - Pause the stopwatch
    resume         - Resume a paused stopwatch
    lap            - Record a lap time
    laps           - Display all recorded laps
    status         - Show current stopwatch state
    reset          - Reset the stopwatch
    help           - Show this help message
    quit/exit      - Exit the application

  """

  @doc """
  Main entry point for the CLI application.
  """
  def main(_args \\ []) do
    IO.puts("\n" <> IO.ANSI.cyan() <> "╔═══════════════════════════════════════╗")
    IO.puts("║   Elixir Stopwatch v1.0.0             ║")
    IO.puts("╚═══════════════════════════════════════╝" <> IO.ANSI.reset())
    IO.puts("Type 'help' for available commands.\n")

    loop(Stopwatch.new())
  end

  defp loop(stopwatch) do
    prompt = get_prompt(stopwatch)
    IO.write(prompt)

    case IO.gets("") |> String.trim() |> String.downcase() do
      "" ->
        loop(stopwatch)

      "quit" ->
        IO.puts(IO.ANSI.green() <> "\nGoodbye! 👋\n" <> IO.ANSI.reset())
        :ok

      "exit" ->
        IO.puts(IO.ANSI.green() <> "\nGoodbye! 👋\n" <> IO.ANSI.reset())
        :ok

      "help" ->
        IO.puts(@commands)
        loop(stopwatch)

      "start" ->
        handle_start(stopwatch)

      "stop" ->
        handle_stop(stopwatch)

      "pause" ->
        handle_pause(stopwatch)

      "resume" ->
        handle_resume(stopwatch)

      "lap" ->
        handle_lap(stopwatch)

      "laps" ->
        handle_laps(stopwatch)
        loop(stopwatch)

      "status" ->
        handle_status(stopwatch)
        loop(stopwatch)

      "reset" ->
        handle_reset(stopwatch)

      command ->
        IO.puts(IO.ANSI.red() <> "Unknown command: #{command}" <> IO.ANSI.reset())
        IO.puts("Type 'help' for available commands.")
        loop(stopwatch)
    end
  end

  defp get_prompt(stopwatch) do
    state_indicator =
      case stopwatch.state do
        :running -> IO.ANSI.green() <> "▶ RUNNING"
        :paused -> IO.ANSI.yellow() <> "⏸ PAUSED"
        :stopped -> IO.ANSI.blue() <> "⏹ STOPPED"
      end

    time_display =
      if stopwatch.state in [:running, :paused] do
        elapsed = Stopwatch.elapsed(stopwatch)
        " | " <> Formatter.format(elapsed, :long)
      else
        ""
      end

    state_indicator <> time_display <> IO.ANSI.reset() <> "\n> "
  end

  defp handle_start(stopwatch) do
    case Stopwatch.start(stopwatch) do
      {:ok, new_stopwatch} ->
        IO.puts(IO.ANSI.green() <> "✓ Stopwatch started!" <> IO.ANSI.reset())
        loop(new_stopwatch)

      {:error, reason} ->
        IO.puts(IO.ANSI.red() <> "✗ Error: #{reason}" <> IO.ANSI.reset())
        loop(stopwatch)
    end
  end

  defp handle_stop(stopwatch) do
    case Stopwatch.stop(stopwatch) do
      {:ok, new_stopwatch, elapsed} ->
        IO.puts(IO.ANSI.green() <> "\n✓ Stopwatch stopped!" <> IO.ANSI.reset())
        IO.puts("Total time: " <> IO.ANSI.cyan() <> Formatter.format(elapsed, :long) <> IO.ANSI.reset())

        if length(stopwatch.laps) > 0 do
          IO.puts("\nLap summary:")
          display_laps(stopwatch)
        end

        IO.puts("")
        loop(new_stopwatch)

      {:error, reason} ->
        IO.puts(IO.ANSI.red() <> "✗ Error: #{reason}" <> IO.ANSI.reset())
        loop(stopwatch)
    end
  end

  defp handle_pause(stopwatch) do
    case Stopwatch.pause(stopwatch) do
      {:ok, new_stopwatch} ->
        elapsed = Stopwatch.elapsed(new_stopwatch)
        IO.puts(IO.ANSI.yellow() <> "⏸ Stopwatch paused at " <> Formatter.format(elapsed, :long) <> IO.ANSI.reset())
        loop(new_stopwatch)

      {:error, reason} ->
        IO.puts(IO.ANSI.red() <> "✗ Error: #{reason}" <> IO.ANSI.reset())
        loop(stopwatch)
    end
  end

  defp handle_resume(stopwatch) do
    case Stopwatch.resume(stopwatch) do
      {:ok, new_stopwatch} ->
        IO.puts(IO.ANSI.green() <> "▶ Stopwatch resumed!" <> IO.ANSI.reset())
        loop(new_stopwatch)

      {:error, reason} ->
        IO.puts(IO.ANSI.red() <> "✗ Error: #{reason}" <> IO.ANSI.reset())
        loop(stopwatch)
    end
  end

  defp handle_lap(stopwatch) do
    case Stopwatch.lap(stopwatch) do
      {:ok, new_stopwatch, lap_time} ->
        lap_number = length(new_stopwatch.laps)
        cumulative = Stopwatch.elapsed(new_stopwatch)

        IO.puts(
          IO.ANSI.cyan() <>
            "Lap #{lap_number}: #{Formatter.format(lap_time, :short)} " <>
            "(Total: #{Formatter.format(cumulative, :long)})" <>
            IO.ANSI.reset()
        )

        loop(new_stopwatch)

      {:error, reason} ->
        IO.puts(IO.ANSI.red() <> "✗ Error: #{reason}" <> IO.ANSI.reset())
        loop(stopwatch)
    end
  end

  defp handle_laps(stopwatch) do
    if length(stopwatch.laps) == 0 do
      IO.puts(IO.ANSI.yellow() <> "No laps recorded yet." <> IO.ANSI.reset())
    else
      IO.puts("\n" <> IO.ANSI.cyan() <> Formatter.lap_table_header() <> IO.ANSI.reset())
      display_laps(stopwatch)
      IO.puts("")
    end
  end

  defp handle_status(stopwatch) do
    IO.puts("\n" <> IO.ANSI.cyan() <> "Stopwatch Status" <> IO.ANSI.reset())
    IO.puts("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

    state_text =
      case stopwatch.state do
        :running -> IO.ANSI.green() <> "RUNNING"
        :paused -> IO.ANSI.yellow() <> "PAUSED"
        :stopped -> IO.ANSI.blue() <> "STOPPED"
      end

    IO.puts("State:        #{state_text}" <> IO.ANSI.reset())

    if stopwatch.state in [:running, :paused] do
      elapsed = Stopwatch.elapsed(stopwatch)
      IO.puts("Elapsed:      #{Formatter.format(elapsed, :long)}")
      IO.puts("Laps:         #{length(stopwatch.laps)}")

      if length(stopwatch.laps) > 0 do
        laps = Stopwatch.get_laps(stopwatch)
        fastest = Enum.min(laps)
        slowest = Enum.max(laps)
        average = div(Enum.sum(laps), length(laps))

        IO.puts("Fastest lap:  #{Formatter.format(fastest, :short)}")
        IO.puts("Slowest lap:  #{Formatter.format(slowest, :short)}")
        IO.puts("Average lap:  #{Formatter.format(average, :short)}")
      end
    end

    IO.puts("")
  end

  defp handle_reset(stopwatch) do
    if stopwatch.state != :stopped do
      IO.write("Are you sure you want to reset? (y/n): ")

      case IO.gets("") |> String.trim() |> String.downcase() do
        "y" ->
          IO.puts(IO.ANSI.green() <> "✓ Stopwatch reset." <> IO.ANSI.reset())
          loop(Stopwatch.reset(stopwatch))

        _ ->
          IO.puts("Reset cancelled.")
          loop(stopwatch)
      end
    else
      loop(Stopwatch.reset(stopwatch))
    end
  end

  defp display_laps(stopwatch) do
    laps = Stopwatch.get_laps(stopwatch)

    laps
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {cumulative_time, index}, prev_time ->
      lap_time = cumulative_time - prev_time
      IO.puts(Formatter.format_lap_row(index, lap_time, cumulative_time))
      cumulative_time
    end)
  end
end
