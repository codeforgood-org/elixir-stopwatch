defmodule Stopwatch do
  def run do
    loop(:stopped, nil)
  end

  defp loop(:stopped, _) do
    IO.puts("Enter command (start | quit):")
    case IO.gets("> ") |> String.trim() do
      "start" ->
        start_time = :os.system_time(:millisecond)
        loop(:running, start_time)
      "quit" ->
        IO.puts("Goodbye!")
      _ ->
        IO.puts("Invalid command.")
        loop(:stopped, nil)
    end
  end

  defp loop(:running, start_time) do
    IO.puts("Enter command (stop | quit):")
    case IO.gets("> ") |> String.trim() do
      "stop" ->
        stop_time = :os.system_time(:millisecond)
        elapsed = stop_time - start_time
        seconds = div(elapsed, 1000)
        IO.puts("Elapsed time: #{seconds} seconds.")
        loop(:stopped, nil)
      "quit" ->
        IO.puts("Goodbye!")
      _ ->
        IO.puts("Invalid command.")
        loop(:running, start_time)
    end
  end
end

Stopwatch.run()
