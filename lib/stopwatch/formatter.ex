defmodule Stopwatch.Formatter do
  @moduledoc """
  Formats elapsed time in various human-readable formats.

  ## Examples

      iex> Stopwatch.Formatter.format(5432)
      "00:05.432"

      iex> Stopwatch.Formatter.format(125432, :long)
      "00:02:05.432"

  """

  @doc """
  Formats milliseconds into a human-readable time string.

  ## Formats

  - `:short` - MM:SS.mmm (default)
  - `:long` - HH:MM:SS.mmm
  - `:compact` - Removes leading zeros and uses minimal format
  - `:verbose` - Full text description (e.g., "2 hours, 5 minutes, 32 seconds")

  ## Examples

      iex> Stopwatch.Formatter.format(1234)
      "00:01.234"

      iex> Stopwatch.Formatter.format(61234, :long)
      "00:01:01.234"

      iex> Stopwatch.Formatter.format(1234, :compact)
      "1.234s"

      iex> Stopwatch.Formatter.format(125432, :verbose)
      "2 minutes, 5 seconds, 432 milliseconds"

  """
  @spec format(integer(), atom()) :: String.t()
  def format(milliseconds, format \\ :short)

  def format(milliseconds, :short) do
    {_hours, minutes, seconds, ms} = breakdown(milliseconds)
    :io_lib.format("~2..0B:~2..0B.~3..0B", [minutes, seconds, ms])
    |> IO.iodata_to_binary()
  end

  def format(milliseconds, :long) do
    {hours, minutes, seconds, ms} = breakdown(milliseconds)
    :io_lib.format("~2..0B:~2..0B:~2..0B.~3..0B", [hours, minutes, seconds, ms])
    |> IO.iodata_to_binary()
  end

  def format(milliseconds, :compact) do
    {hours, minutes, seconds, ms} = breakdown(milliseconds)

    cond do
      hours > 0 ->
        "#{hours}h #{minutes}m #{seconds}.#{String.pad_leading(Integer.to_string(ms), 3, "0")}s"

      minutes > 0 ->
        "#{minutes}m #{seconds}.#{String.pad_leading(Integer.to_string(ms), 3, "0")}s"

      seconds > 0 ->
        "#{seconds}.#{String.pad_leading(Integer.to_string(ms), 3, "0")}s"

      true ->
        "#{ms}ms"
    end
  end

  def format(milliseconds, :verbose) do
    {hours, minutes, seconds, ms} = breakdown(milliseconds)

    parts =
      [
        {hours, "hour"},
        {minutes, "minute"},
        {seconds, "second"},
        {ms, "millisecond"}
      ]
      |> Enum.filter(fn {value, _} -> value > 0 end)
      |> Enum.map(fn {value, unit} ->
        if value == 1, do: "#{value} #{unit}", else: "#{value} #{unit}s"
      end)

    case parts do
      [] -> "0 milliseconds"
      [single] -> single
      [first | rest] -> Enum.join(rest ++ [first], ", ")
    end
  end

  @doc """
  Formats milliseconds into a simple seconds.milliseconds format.

  ## Examples

      iex> Stopwatch.Formatter.format_seconds(5432)
      "5.432"

  """
  @spec format_seconds(integer()) :: String.t()
  def format_seconds(milliseconds) do
    seconds = div(milliseconds, 1000)
    ms = rem(milliseconds, 1000)
    "#{seconds}.#{String.pad_leading(Integer.to_string(ms), 3, "0")}"
  end

  @doc """
  Breaks down milliseconds into hours, minutes, seconds, and milliseconds.

  ## Examples

      iex> Stopwatch.Formatter.breakdown(125432)
      {0, 2, 5, 432}

  """
  @spec breakdown(integer()) :: {integer(), integer(), integer(), integer()}
  def breakdown(milliseconds) do
    total_seconds = div(milliseconds, 1000)
    ms = rem(milliseconds, 1000)

    hours = div(total_seconds, 3600)
    remaining_seconds = rem(total_seconds, 3600)

    minutes = div(remaining_seconds, 60)
    seconds = rem(remaining_seconds, 60)

    {hours, minutes, seconds, ms}
  end

  @doc """
  Creates a formatted table row for displaying lap information.

  ## Examples

      iex> Stopwatch.Formatter.format_lap_row(1, 5432, 5432)
      "  1        00:05.432    00:05.432"

  """
  @spec format_lap_row(integer(), integer(), integer()) :: String.t()
  def format_lap_row(lap_number, lap_time, cumulative_time) do
    lap_str = String.pad_leading(Integer.to_string(lap_number), 3)
    lap_time_str = format(lap_time, :short)
    cumulative_str = format(cumulative_time, :short)

    "  #{lap_str}      #{lap_time_str}      #{cumulative_str}"
  end

  @doc """
  Creates a header for lap time tables.

  ## Examples

      iex> Stopwatch.Formatter.lap_table_header()
      "  Lap      Lap Time     Total Time"

  """
  @spec lap_table_header() :: String.t()
  def lap_table_header do
    "  Lap      Lap Time     Total Time\n" <>
      "  ----------------------------------------"
  end
end
