# Benchmarking suite for Stopwatch module
#
# Run with: mix run bench/stopwatch_bench.exs

defmodule StopwatchBench do
  def run do
    IO.puts("=" |> String.duplicate(60))
    IO.puts("Stopwatch Performance Benchmarks")
    IO.puts("=" |> String.duplicate(60))
    IO.puts("")

    benchmark_creation()
    benchmark_start_stop()
    benchmark_lap_recording()
    benchmark_pause_resume()
    benchmark_elapsed_calculation()
    benchmark_formatting()
    benchmark_export()

    IO.puts("\n" <> ("=" |> String.duplicate(60)))
    IO.puts("Benchmarks Complete")
    IO.puts("=" |> String.duplicate(60)))
  end

  defp benchmark_creation do
    IO.puts("Benchmarking: Stopwatch creation")

    {time, _result} =
      :timer.tc(fn ->
        Enum.each(1..10_000, fn _ ->
          Stopwatch.new()
        end)
      end)

    avg_time = time / 10_000
    IO.puts("  10,000 iterations: #{time} μs total")
    IO.puts("  Average: #{Float.round(avg_time, 2)} μs per operation")
    IO.puts("")
  end

  defp benchmark_start_stop do
    IO.puts("Benchmarking: Start and stop operations")

    {time, _result} =
      :timer.tc(fn ->
        Enum.each(1..10_000, fn _ ->
          stopwatch = Stopwatch.new()
          {:ok, stopwatch} = Stopwatch.start(stopwatch)
          Stopwatch.stop(stopwatch)
        end)
      end)

    avg_time = time / 10_000
    IO.puts("  10,000 iterations: #{time} μs total")
    IO.puts("  Average: #{Float.round(avg_time, 2)} μs per operation")
    IO.puts("")
  end

  defp benchmark_lap_recording do
    IO.puts("Benchmarking: Lap recording (100 laps)")

    {time, _result} =
      :timer.tc(fn ->
        Enum.each(1..100, fn _ ->
          {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()

          stopwatch =
            Enum.reduce(1..100, stopwatch, fn _, sw ->
              {:ok, sw, _} = Stopwatch.lap(sw)
              sw
            end)

          Stopwatch.stop(stopwatch)
        end)
      end)

    avg_time = time / 100
    IO.puts("  100 iterations: #{time} μs total")
    IO.puts("  Average: #{Float.round(avg_time, 2)} μs per operation")
    IO.puts("")
  end

  defp benchmark_pause_resume do
    IO.puts("Benchmarking: Pause and resume operations")

    {time, _result} =
      :timer.tc(fn ->
        Enum.each(1..10_000, fn _ ->
          {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()
          {:ok, paused} = Stopwatch.pause(stopwatch)
          {:ok, resumed} = Stopwatch.resume(paused)
          Stopwatch.stop(resumed)
        end)
      end)

    avg_time = time / 10_000
    IO.puts("  10,000 iterations: #{time} μs total")
    IO.puts("  Average: #{Float.round(avg_time, 2)} μs per operation")
    IO.puts("")
  end

  defp benchmark_elapsed_calculation do
    IO.puts("Benchmarking: Elapsed time calculation")

    {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()

    {time, _result} =
      :timer.tc(fn ->
        Enum.each(1..100_000, fn _ ->
          Stopwatch.elapsed(stopwatch)
        end)
      end)

    avg_time = time / 100_000
    IO.puts("  100,000 iterations: #{time} μs total")
    IO.puts("  Average: #{Float.round(avg_time, 2)} μs per operation")
    IO.puts("")
  end

  defp benchmark_formatting do
    IO.puts("Benchmarking: Time formatting")

    time_ms = 3_661_234

    formats = [:short, :long, :compact, :verbose]

    Enum.each(formats, fn format ->
      {time, _result} =
        :timer.tc(fn ->
          Enum.each(1..10_000, fn _ ->
            Stopwatch.Formatter.format(time_ms, format)
          end)
        end)

      avg_time = time / 10_000
      IO.puts("  Format :#{format} - 10,000 iterations: #{time} μs total")
      IO.puts("    Average: #{Float.round(avg_time, 2)} μs per operation")
    end)

    IO.puts("")
  end

  defp benchmark_export do
    IO.puts("Benchmarking: Export operations")

    # Create a stopwatch with some data
    {:ok, stopwatch} = Stopwatch.new() |> Stopwatch.start()

    stopwatch =
      Enum.reduce(1..10, stopwatch, fn _, sw ->
        {:ok, sw, _} = Stopwatch.lap(sw)
        sw
      end)

    # JSON export
    {time, _result} =
      :timer.tc(fn ->
        Enum.each(1..1_000, fn _ ->
          Stopwatch.Export.to_json(stopwatch)
        end)
      end)

    avg_time = time / 1_000
    IO.puts("  JSON export - 1,000 iterations: #{time} μs total")
    IO.puts("    Average: #{Float.round(avg_time, 2)} μs per operation")

    # CSV export
    {time, _result} =
      :timer.tc(fn ->
        Enum.each(1..1_000, fn _ ->
          Stopwatch.Export.laps_to_csv(stopwatch)
        end)
      end)

    avg_time = time / 1_000
    IO.puts("  CSV export - 1,000 iterations: #{time} μs total")
    IO.puts("    Average: #{Float.round(avg_time, 2)} μs per operation")
    IO.puts("")
  end
end

# Run benchmarks
StopwatchBench.run()
