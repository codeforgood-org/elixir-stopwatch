defmodule Stopwatch do
  @moduledoc """
  A feature-rich stopwatch module with support for lap timing, pause/resume, and history tracking.

  ## Features

  - Start, stop, pause, and resume timing
  - Record lap times while running
  - Track multiple stopwatch sessions
  - High-precision timing using system monotonic time
  - Comprehensive history of all timing events

  ## Examples

      iex> stopwatch = Stopwatch.new()
      iex> {:ok, stopwatch} = Stopwatch.start(stopwatch)
      iex> Process.sleep(1000)
      iex> {:ok, stopwatch, lap_time} = Stopwatch.lap(stopwatch)
      iex> elapsed = Stopwatch.elapsed(stopwatch)

  """

  defstruct [
    :state,
    :start_time,
    :pause_time,
    :total_paused,
    :laps,
    :history
  ]

  @type state :: :stopped | :running | :paused
  @type t :: %__MODULE__{
          state: state(),
          start_time: integer() | nil,
          pause_time: integer() | nil,
          total_paused: integer(),
          laps: [integer()],
          history: [history_entry()]
        }

  @type history_entry :: %{
          action: atom(),
          timestamp: integer(),
          elapsed: integer() | nil
        }

  @doc """
  Creates a new stopwatch instance in the stopped state.

  ## Examples

      iex> stopwatch = Stopwatch.new()
      iex> stopwatch.state
      :stopped

  """
  @spec new() :: t()
  def new do
    %__MODULE__{
      state: :stopped,
      start_time: nil,
      pause_time: nil,
      total_paused: 0,
      laps: [],
      history: []
    }
  end

  @doc """
  Starts the stopwatch. Returns an error if already running or paused.

  ## Examples

      iex> stopwatch = Stopwatch.new()
      iex> {:ok, running} = Stopwatch.start(stopwatch)
      iex> running.state
      :running

  """
  @spec start(t()) :: {:ok, t()} | {:error, String.t()}
  def start(%__MODULE__{state: :stopped} = stopwatch) do
    now = current_time()

    updated =
      stopwatch
      |> Map.put(:state, :running)
      |> Map.put(:start_time, now)
      |> Map.put(:total_paused, 0)
      |> Map.put(:laps, [])
      |> add_history(:start, now, 0)

    {:ok, updated}
  end

  def start(%__MODULE__{state: state}) do
    {:error, "Cannot start stopwatch from state: #{state}"}
  end

  @doc """
  Stops the stopwatch and returns the total elapsed time.

  ## Examples

      iex> {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      iex> {:ok, stopped, elapsed} = Stopwatch.stop(stopwatch)
      iex> stopped.state
      :stopped

  """
  @spec stop(t()) :: {:ok, t(), integer()} | {:error, String.t()}
  def stop(%__MODULE__{state: state} = stopwatch) when state in [:running, :paused] do
    elapsed = elapsed(stopwatch)

    updated =
      stopwatch
      |> Map.put(:state, :stopped)
      |> Map.put(:start_time, nil)
      |> Map.put(:pause_time, nil)
      |> add_history(:stop, current_time(), elapsed)

    {:ok, updated, elapsed}
  end

  def stop(%__MODULE__{state: :stopped}) do
    {:error, "Stopwatch is already stopped"}
  end

  @doc """
  Pauses a running stopwatch.

  ## Examples

      iex> {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      iex> {:ok, paused} = Stopwatch.pause(stopwatch)
      iex> paused.state
      :paused

  """
  @spec pause(t()) :: {:ok, t()} | {:error, String.t()}
  def pause(%__MODULE__{state: :running} = stopwatch) do
    now = current_time()
    elapsed = elapsed(stopwatch)

    updated =
      stopwatch
      |> Map.put(:state, :paused)
      |> Map.put(:pause_time, now)
      |> add_history(:pause, now, elapsed)

    {:ok, updated}
  end

  def pause(%__MODULE__{state: state}) do
    {:error, "Cannot pause stopwatch from state: #{state}"}
  end

  @doc """
  Resumes a paused stopwatch.

  ## Examples

      iex> {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      iex> {:ok, paused} = Stopwatch.pause(stopwatch)
      iex> {:ok, resumed} = Stopwatch.resume(paused)
      iex> resumed.state
      :running

  """
  @spec resume(t()) :: {:ok, t()} | {:error, String.t()}
  def resume(%__MODULE__{state: :paused, pause_time: pause_time} = stopwatch) do
    now = current_time()
    pause_duration = now - pause_time
    elapsed = elapsed(stopwatch)

    updated =
      stopwatch
      |> Map.put(:state, :running)
      |> Map.put(:pause_time, nil)
      |> Map.update!(:total_paused, &(&1 + pause_duration))
      |> add_history(:resume, now, elapsed)

    {:ok, updated}
  end

  def resume(%__MODULE__{state: state}) do
    {:error, "Cannot resume stopwatch from state: #{state}"}
  end

  @doc """
  Records a lap time for a running or paused stopwatch.

  Returns the lap time (time since last lap or start) and cumulative elapsed time.

  ## Examples

      iex> {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      iex> Process.sleep(100)
      iex> {:ok, stopwatch, lap_time} = Stopwatch.lap(stopwatch)

  """
  @spec lap(t()) :: {:ok, t(), integer()} | {:error, String.t()}
  def lap(%__MODULE__{state: state} = stopwatch) when state in [:running, :paused] do
    now = current_time()
    elapsed = elapsed(stopwatch)

    previous_lap_time = List.first(stopwatch.laps) || 0
    lap_time = elapsed - previous_lap_time

    updated =
      stopwatch
      |> Map.update!(:laps, &[elapsed | &1])
      |> add_history(:lap, now, elapsed)

    {:ok, updated, lap_time}
  end

  def lap(%__MODULE__{state: :stopped}) do
    {:error, "Cannot record lap while stopped"}
  end

  @doc """
  Returns the current elapsed time in milliseconds.

  For a running stopwatch, returns the time since start minus any paused time.
  For a paused stopwatch, returns the time at pause.
  For a stopped stopwatch, returns 0.

  ## Examples

      iex> stopwatch = Stopwatch.new()
      iex> Stopwatch.elapsed(stopwatch)
      0

  """
  @spec elapsed(t()) :: integer()
  def elapsed(%__MODULE__{state: :stopped}), do: 0

  def elapsed(%__MODULE__{state: :running, start_time: start_time, total_paused: total_paused}) do
    current_time() - start_time - total_paused
  end

  def elapsed(%__MODULE__{
        state: :paused,
        start_time: start_time,
        pause_time: pause_time,
        total_paused: total_paused
      }) do
    pause_time - start_time - total_paused
  end

  @doc """
  Returns all recorded lap times in chronological order (oldest first).

  ## Examples

      iex> {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      iex> {:ok, stopwatch, _} = Stopwatch.lap(stopwatch)
      iex> laps = Stopwatch.get_laps(stopwatch)

  """
  @spec get_laps(t()) :: [integer()]
  def get_laps(%__MODULE__{laps: laps}) do
    Enum.reverse(laps)
  end

  @doc """
  Returns the complete history of all stopwatch events.

  ## Examples

      iex> {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      iex> history = Stopwatch.get_history(stopwatch)

  """
  @spec get_history(t()) :: [history_entry()]
  def get_history(%__MODULE__{history: history}) do
    Enum.reverse(history)
  end

  @doc """
  Resets the stopwatch to a stopped state, clearing all data.

  ## Examples

      iex> {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      iex> reset = Stopwatch.reset(stopwatch)
      iex> reset.state
      :stopped

  """
  @spec reset(t()) :: t()
  def reset(_stopwatch) do
    new()
  end

  # Private functions

  defp current_time do
    System.monotonic_time(:millisecond)
  end

  defp add_history(stopwatch, action, timestamp, elapsed) do
    entry = %{
      action: action,
      timestamp: timestamp,
      elapsed: elapsed
    }

    Map.update!(stopwatch, :history, &[entry | &1])
  end
end
