defmodule Stopwatch.FormatterTest do
  use ExUnit.Case
  doctest Stopwatch.Formatter

  alias Stopwatch.Formatter

  describe "format/2 with :short format" do
    test "formats milliseconds correctly" do
      assert Formatter.format(1234, :short) == "00:01.234"
      assert Formatter.format(5432, :short) == "00:05.432"
      assert Formatter.format(59999, :short) == "00:59.999"
    end

    test "formats minutes correctly" do
      assert Formatter.format(61000, :short) == "01:01.000"
      assert Formatter.format(125432, :short) == "02:05.432"
    end

    test "formats hours as minutes in short format" do
      assert Formatter.format(3661000, :short) == "61:01.000"
    end
  end

  describe "format/2 with :long format" do
    test "formats with hours, minutes, seconds, and milliseconds" do
      assert Formatter.format(1234, :long) == "00:00:01.234"
      assert Formatter.format(61234, :long) == "00:01:01.234"
      assert Formatter.format(3661234, :long) == "01:01:01.234"
    end

    test "handles large durations" do
      assert Formatter.format(36_000_000, :long) == "10:00:00.000"
    end
  end

  describe "format/2 with :compact format" do
    test "formats milliseconds only" do
      assert Formatter.format(123, :compact) == "123ms"
      assert Formatter.format(999, :compact) == "999ms"
    end

    test "formats seconds compactly" do
      assert Formatter.format(1234, :compact) == "1.234s"
      assert Formatter.format(5432, :compact) == "5.432s"
    end

    test "formats minutes compactly" do
      assert Formatter.format(125432, :compact) == "2m 5.432s"
      assert Formatter.format(61000, :compact) == "1m 1.000s"
    end

    test "formats hours compactly" do
      assert Formatter.format(3661234, :compact) == "1h 1m 1.234s"
    end
  end

  describe "format/2 with :verbose format" do
    test "formats single units" do
      assert Formatter.format(1, :verbose) == "1 millisecond"
      assert Formatter.format(1000, :verbose) == "1 second"
      assert Formatter.format(60_000, :verbose) == "1 minute"
      assert Formatter.format(3_600_000, :verbose) == "1 hour"
    end

    test "formats multiple units" do
      assert Formatter.format(1234, :verbose) == "234 milliseconds, 1 second"
      assert Formatter.format(61234, :verbose) == "234 milliseconds, 1 second, 1 minute"

      assert Formatter.format(3661234, :verbose) ==
               "234 milliseconds, 1 second, 1 minute, 1 hour"
    end

    test "pluralizes correctly" do
      assert Formatter.format(2000, :verbose) == "2 seconds"
      assert Formatter.format(120_000, :verbose) == "2 minutes"
      assert Formatter.format(7_200_000, :verbose) == "2 hours"
    end

    test "skips zero values" do
      assert Formatter.format(3_600_000, :verbose) == "1 hour"
      assert Formatter.format(61_000, :verbose) == "1 second, 1 minute"
    end
  end

  describe "format_seconds/1" do
    test "formats as decimal seconds" do
      assert Formatter.format_seconds(1234) == "1.234"
      assert Formatter.format_seconds(5432) == "5.432"
      assert Formatter.format_seconds(61234) == "61.234"
    end

    test "pads milliseconds with leading zeros" do
      assert Formatter.format_seconds(1001) == "1.001"
      assert Formatter.format_seconds(5010) == "5.010"
    end
  end

  describe "breakdown/1" do
    test "breaks down milliseconds into components" do
      assert Formatter.breakdown(1234) == {0, 0, 1, 234}
      assert Formatter.breakdown(61234) == {0, 1, 1, 234}
      assert Formatter.breakdown(3661234) == {1, 1, 1, 234}
    end

    test "handles zero" do
      assert Formatter.breakdown(0) == {0, 0, 0, 0}
    end

    test "handles large values" do
      assert Formatter.breakdown(36_000_000) == {10, 0, 0, 0}
      assert Formatter.breakdown(90_061_234) == {25, 1, 1, 234}
    end
  end

  describe "format_lap_row/3" do
    test "formats lap information in a table row" do
      result = Formatter.format_lap_row(1, 5432, 5432)
      assert result =~ "1"
      assert result =~ "00:05.432"
    end

    test "handles multi-digit lap numbers" do
      result = Formatter.format_lap_row(42, 1234, 61234)
      assert result =~ "42"
    end
  end

  describe "lap_table_header/0" do
    test "returns a properly formatted header" do
      header = Formatter.lap_table_header()
      assert header =~ "Lap"
      assert header =~ "Lap Time"
      assert header =~ "Total Time"
    end
  end
end
