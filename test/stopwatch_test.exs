defmodule StopwatchTest do
  use ExUnit.Case
  doctest Stopwatch

  describe "new/0" do
    test "creates a new stopwatch in stopped state" do
      stopwatch = Stopwatch.new()

      assert stopwatch.state == :stopped
      assert stopwatch.start_time == nil
      assert stopwatch.pause_time == nil
      assert stopwatch.total_paused == 0
      assert stopwatch.laps == []
      assert stopwatch.history == []
    end
  end

  describe "start/1" do
    test "starts a stopped stopwatch" do
      stopwatch = Stopwatch.new()
      {:ok, started} = Stopwatch.start(stopwatch)

      assert started.state == :running
      assert started.start_time != nil
      assert started.total_paused == 0
    end

    test "returns error when starting a running stopwatch" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      result = Stopwatch.start(stopwatch)

      assert {:error, _} = result
    end

    test "returns error when starting a paused stopwatch" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      {:ok, paused} = Stopwatch.pause(stopwatch)
      result = Stopwatch.start(paused)

      assert {:error, _} = result
    end
  end

  describe "stop/1" do
    test "stops a running stopwatch" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      Process.sleep(10)
      {:ok, stopped, elapsed} = Stopwatch.stop(stopwatch)

      assert stopped.state == :stopped
      assert elapsed >= 10
      assert stopped.start_time == nil
      assert stopped.pause_time == nil
    end

    test "stops a paused stopwatch" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      Process.sleep(10)
      {:ok, paused} = Stopwatch.pause(stopwatch)
      {:ok, stopped, elapsed} = Stopwatch.stop(paused)

      assert stopped.state == :stopped
      assert elapsed >= 10
    end

    test "returns error when stopping an already stopped stopwatch" do
      stopwatch = Stopwatch.new()
      result = Stopwatch.stop(stopwatch)

      assert {:error, _} = result
    end
  end

  describe "pause/1" do
    test "pauses a running stopwatch" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      Process.sleep(10)
      {:ok, paused} = Stopwatch.pause(stopwatch)

      assert paused.state == :paused
      assert paused.pause_time != nil
    end

    test "returns error when pausing a stopped stopwatch" do
      stopwatch = Stopwatch.new()
      result = Stopwatch.pause(stopwatch)

      assert {:error, _} = result
    end

    test "returns error when pausing an already paused stopwatch" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      {:ok, paused} = Stopwatch.pause(stopwatch)
      result = Stopwatch.pause(paused)

      assert {:error, _} = result
    end
  end

  describe "resume/1" do
    test "resumes a paused stopwatch" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      Process.sleep(10)
      {:ok, paused} = Stopwatch.pause(stopwatch)
      Process.sleep(10)
      {:ok, resumed} = Stopwatch.resume(paused)

      assert resumed.state == :running
      assert resumed.pause_time == nil
      assert resumed.total_paused > 0
    end

    test "returns error when resuming a stopped stopwatch" do
      stopwatch = Stopwatch.new()
      result = Stopwatch.resume(stopwatch)

      assert {:error, _} = result
    end

    test "returns error when resuming a running stopwatch" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      result = Stopwatch.resume(stopwatch)

      assert {:error, _} = result
    end
  end

  describe "lap/1" do
    test "records a lap on a running stopwatch" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      Process.sleep(10)
      {:ok, with_lap, lap_time} = Stopwatch.lap(stopwatch)

      assert length(with_lap.laps) == 1
      assert lap_time >= 10
    end

    test "records multiple laps" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      Process.sleep(10)
      {:ok, stopwatch, _} = Stopwatch.lap(stopwatch)
      Process.sleep(10)
      {:ok, stopwatch, _} = Stopwatch.lap(stopwatch)

      assert length(stopwatch.laps) == 2
    end

    test "can record lap on paused stopwatch" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      Process.sleep(10)
      {:ok, paused} = Stopwatch.pause(stopwatch)
      {:ok, with_lap, lap_time} = Stopwatch.lap(paused)

      assert length(with_lap.laps) == 1
      assert lap_time >= 10
    end

    test "returns error when recording lap on stopped stopwatch" do
      stopwatch = Stopwatch.new()
      result = Stopwatch.lap(stopwatch)

      assert {:error, _} = result
    end
  end

  describe "elapsed/1" do
    test "returns 0 for stopped stopwatch" do
      stopwatch = Stopwatch.new()
      assert Stopwatch.elapsed(stopwatch) == 0
    end

    test "returns elapsed time for running stopwatch" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      Process.sleep(20)
      elapsed = Stopwatch.elapsed(stopwatch)

      assert elapsed >= 20
    end

    test "returns time at pause for paused stopwatch" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      Process.sleep(20)
      {:ok, paused} = Stopwatch.pause(stopwatch)
      elapsed_at_pause = Stopwatch.elapsed(paused)

      Process.sleep(20)
      elapsed_after_wait = Stopwatch.elapsed(paused)

      # Elapsed time should not increase while paused
      assert elapsed_at_pause == elapsed_after_wait
      assert elapsed_at_pause >= 20
    end

    test "correctly accounts for pause time" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      Process.sleep(20)
      {:ok, paused} = Stopwatch.pause(stopwatch)
      Process.sleep(20)
      {:ok, resumed} = Stopwatch.resume(paused)
      Process.sleep(20)
      elapsed = Stopwatch.elapsed(resumed)

      # Should be around 40ms (20 + 20), not 60ms
      assert elapsed >= 40
      assert elapsed < 60
    end
  end

  describe "get_laps/1" do
    test "returns empty list for stopwatch without laps" do
      stopwatch = Stopwatch.new()
      assert Stopwatch.get_laps(stopwatch) == []
    end

    test "returns laps in chronological order" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      Process.sleep(10)
      {:ok, stopwatch, _} = Stopwatch.lap(stopwatch)
      Process.sleep(10)
      {:ok, stopwatch, _} = Stopwatch.lap(stopwatch)

      laps = Stopwatch.get_laps(stopwatch)
      assert length(laps) == 2
      assert Enum.at(laps, 0) < Enum.at(laps, 1)
    end
  end

  describe "get_history/1" do
    test "returns empty list for new stopwatch" do
      stopwatch = Stopwatch.new()
      assert Stopwatch.get_history(stopwatch) == []
    end

    test "tracks all events in chronological order" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      Process.sleep(10)
      {:ok, paused} = Stopwatch.pause(stopwatch)
      {:ok, resumed} = Stopwatch.resume(paused)
      {:ok, stopped, _} = Stopwatch.stop(resumed)

      history = Stopwatch.get_history(stopped)
      actions = Enum.map(history, & &1.action)

      assert actions == [:start, :pause, :resume, :stop]
    end
  end

  describe "reset/1" do
    test "resets a stopped stopwatch" do
      stopwatch = Stopwatch.new()
      reset = Stopwatch.reset(stopwatch)

      assert reset.state == :stopped
      assert reset.laps == []
      assert reset.history == []
    end

    test "resets a running stopwatch with laps" do
      {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
      Process.sleep(10)
      {:ok, stopwatch, _} = Stopwatch.lap(stopwatch)
      reset = Stopwatch.reset(stopwatch)

      assert reset.state == :stopped
      assert reset.laps == []
      assert reset.history == []
    end
  end
end
