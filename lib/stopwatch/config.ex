defmodule Stopwatch.Config do
  @moduledoc """
  Configuration management for Stopwatch.

  Supports loading configuration from a file or using default settings.
  """

  @default_config %{
    default_format: :long,
    auto_save: false,
    auto_save_interval: 60_000,
    color_enabled: true,
    sound_enabled: false,
    history_limit: 1000
  }

  @config_file ".stopwatch.config.json"

  @doc """
  Loads configuration from file or returns defaults.

  ## Examples

      iex> Stopwatch.Config.load()
      {:ok, %{default_format: :long, ...}}

  """
  @spec load() :: {:ok, map()} | {:error, term()}
  def load do
    case File.read(@config_file) do
      {:ok, content} ->
        case Jason.decode(content, keys: :atoms) do
          {:ok, config} ->
            merged = Map.merge(@default_config, config)
            {:ok, merged}

          {:error, reason} ->
            {:error, {:json_decode_error, reason}}
        end

      {:error, :enoent} ->
        {:ok, @default_config}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Saves configuration to file.

  ## Examples

      iex> config = %{default_format: :short}
      iex> Stopwatch.Config.save(config)
      :ok

  """
  @spec save(map()) :: :ok | {:error, term()}
  def save(config) do
    case Jason.encode(config, pretty: true) do
      {:ok, json} ->
        File.write(@config_file, json)

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Returns the default configuration.

  ## Examples

      iex> Stopwatch.Config.defaults()
      %{default_format: :long, ...}

  """
  @spec defaults() :: map()
  def defaults, do: @default_config

  @doc """
  Gets a specific configuration value.

  ## Examples

      iex> config = Stopwatch.Config.defaults()
      iex> Stopwatch.Config.get(config, :default_format)
      :long

  """
  @spec get(map(), atom(), any()) :: any()
  def get(config, key, default \\ nil) do
    Map.get(config, key, default)
  end

  @doc """
  Updates a configuration value.

  ## Examples

      iex> config = Stopwatch.Config.defaults()
      iex> updated = Stopwatch.Config.put(config, :default_format, :short)
      iex> updated.default_format
      :short

  """
  @spec put(map(), atom(), any()) :: map()
  def put(config, key, value) do
    Map.put(config, key, value)
  end
end
