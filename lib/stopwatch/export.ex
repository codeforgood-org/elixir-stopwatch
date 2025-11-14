defmodule Stopwatch.Export do
  @moduledoc """
  Export stopwatch data to various formats (JSON, CSV).

  ## Examples

      iex> {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      iex> {:ok, stopwatch, _} = Stopwatch.lap(stopwatch)
      iex> {:ok, json} = Stopwatch.Export.to_json(stopwatch)

  """

  alias Stopwatch.Formatter

  @doc """
  Exports stopwatch data to JSON format.

  Returns a JSON string containing all stopwatch information including
  state, elapsed time, laps, and history.

  ## Examples

      iex> stopwatch = Stopwatch.new()
      iex> {:ok, json} = Stopwatch.Export.to_json(stopwatch)

  """
  @spec to_json(Stopwatch.t()) :: {:ok, String.t()} | {:error, term()}
  def to_json(stopwatch) do
    data = %{
      state: stopwatch.state,
      elapsed: Stopwatch.elapsed(stopwatch),
      elapsed_formatted: Formatter.format(Stopwatch.elapsed(stopwatch), :long),
      laps: format_laps_for_export(stopwatch),
      lap_count: length(stopwatch.laps),
      history: format_history_for_export(stopwatch),
      statistics: calculate_statistics(stopwatch)
    }

    case Jason.encode(data, pretty: true) do
      {:ok, json} -> {:ok, json}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Exports stopwatch data to JSON and saves to a file.

  ## Examples

      iex> {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      iex> Stopwatch.Export.to_json_file(stopwatch, "stopwatch_data.json")
      {:ok, "stopwatch_data.json"}

  """
  @spec to_json_file(Stopwatch.t(), String.t()) :: {:ok, String.t()} | {:error, term()}
  def to_json_file(stopwatch, filename) do
    with {:ok, json} <- to_json(stopwatch),
         :ok <- File.write(filename, json) do
      {:ok, filename}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Exports lap data to CSV format.

  Returns a CSV string with lap information including lap number,
  lap time, cumulative time, and formatted times.

  ## Examples

      iex> {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      iex> {:ok, stopwatch, _} = Stopwatch.lap(stopwatch)
      iex> csv = Stopwatch.Export.laps_to_csv(stopwatch)

  """
  @spec laps_to_csv(Stopwatch.t()) :: String.t()
  def laps_to_csv(stopwatch) do
    header = "Lap,Lap Time (ms),Cumulative Time (ms),Lap Time (formatted),Cumulative Time (formatted)\n"

    laps = Stopwatch.get_laps(stopwatch)

    rows =
      laps
      |> Enum.with_index(1)
      |> Enum.reduce({[], 0}, fn {cumulative_time, index}, {acc, prev_time} ->
        lap_time = cumulative_time - prev_time
        lap_time_fmt = Formatter.format(lap_time, :short)
        cumulative_fmt = Formatter.format(cumulative_time, :short)

        row = "#{index},#{lap_time},#{cumulative_time},#{lap_time_fmt},#{cumulative_fmt}\n"
        {[row | acc], cumulative_time}
      end)
      |> elem(0)
      |> Enum.reverse()
      |> Enum.join()

    header <> rows
  end

  @doc """
  Exports lap data to CSV file.

  ## Examples

      iex> {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      iex> {:ok, stopwatch, _} = Stopwatch.lap(stopwatch)
      iex> Stopwatch.Export.laps_to_csv_file(stopwatch, "laps.csv")
      {:ok, "laps.csv"}

  """
  @spec laps_to_csv_file(Stopwatch.t(), String.t()) :: {:ok, String.t()} | {:error, term()}
  def laps_to_csv_file(stopwatch, filename) do
    csv = laps_to_csv(stopwatch)

    case File.write(filename, csv) do
      :ok -> {:ok, filename}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Exports full history to CSV format.

  Returns a CSV string with all stopwatch events including timestamps,
  actions, and elapsed times.

  ## Examples

      iex> {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      iex> csv = Stopwatch.Export.history_to_csv(stopwatch)

  """
  @spec history_to_csv(Stopwatch.t()) :: String.t()
  def history_to_csv(stopwatch) do
    header = "Timestamp,Action,Elapsed (ms),Elapsed (formatted)\n"

    rows =
      stopwatch
      |> Stopwatch.get_history()
      |> Enum.map(fn entry ->
        elapsed_fmt = if entry.elapsed, do: Formatter.format(entry.elapsed, :long), else: "N/A"
        elapsed_ms = entry.elapsed || 0

        "#{entry.timestamp},#{entry.action},#{elapsed_ms},#{elapsed_fmt}\n"
      end)
      |> Enum.join()

    header <> rows
  end

  @doc """
  Exports history to CSV file.

  ## Examples

      iex> {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      iex> Stopwatch.Export.history_to_csv_file(stopwatch, "history.csv")
      {:ok, "history.csv"}

  """
  @spec history_to_csv_file(Stopwatch.t(), String.t()) :: {:ok, String.t()} | {:error, term()}
  def history_to_csv_file(stopwatch, filename) do
    csv = history_to_csv(stopwatch)

    case File.write(filename, csv) do
      :ok -> {:ok, filename}
      {:error, reason} -> {:error, reason}
    end
  end

  # Private functions

  defp format_laps_for_export(stopwatch) do
    laps = Stopwatch.get_laps(stopwatch)

    laps
    |> Enum.with_index(1)
    |> Enum.reduce({[], 0}, fn {cumulative_time, index}, {acc, prev_time} ->
      lap_time = cumulative_time - prev_time

      lap_data = %{
        lap_number: index,
        lap_time_ms: lap_time,
        lap_time_formatted: Formatter.format(lap_time, :short),
        cumulative_time_ms: cumulative_time,
        cumulative_time_formatted: Formatter.format(cumulative_time, :long)
      }

      {[lap_data | acc], cumulative_time}
    end)
    |> elem(0)
    |> Enum.reverse()
  end

  defp format_history_for_export(stopwatch) do
    stopwatch
    |> Stopwatch.get_history()
    |> Enum.map(fn entry ->
      %{
        timestamp: entry.timestamp,
        action: entry.action,
        elapsed_ms: entry.elapsed,
        elapsed_formatted:
          if entry.elapsed do
            Formatter.format(entry.elapsed, :long)
          else
            nil
          end
      }
    end)
  end

  defp calculate_statistics(stopwatch) do
    laps = Stopwatch.get_laps(stopwatch)

    if length(laps) > 0 do
      lap_times =
        laps
        |> Enum.chunk_every(2, 1, [0])
        |> Enum.map(fn
          [curr, prev] -> curr - prev
          [curr] -> curr
        end)

      fastest = Enum.min(lap_times)
      slowest = Enum.max(lap_times)
      average = div(Enum.sum(lap_times), length(lap_times))

      %{
        fastest_lap_ms: fastest,
        fastest_lap_formatted: Formatter.format(fastest, :short),
        slowest_lap_ms: slowest,
        slowest_lap_formatted: Formatter.format(slowest, :short),
        average_lap_ms: average,
        average_lap_formatted: Formatter.format(average, :short),
        total_laps: length(laps)
      }
    else
      %{
        fastest_lap_ms: nil,
        fastest_lap_formatted: nil,
        slowest_lap_ms: nil,
        slowest_lap_formatted: nil,
        average_lap_ms: nil,
        average_lap_formatted: nil,
        total_laps: 0
      }
    end
  end
end
