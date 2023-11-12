defmodule ExBackblaze.Config do
  @moduledoc """
  Stores configuration variables used to communicate with private backblaze b2 buckets

  config :ex_backblaze,
    application_key_id: {:system, "BACKBLAZE_APPLICATION_KEY_ID"},
    application_key:  {:system, "BACKBLAZE_APPLICATION_KEY"}
  """

  @doc """
  Returns the backblaze application key id

      config :ex_backblaze, application_key_id: "your application key id"
  """
  def application_key_id, do: from_env(:ex_backblaze, :application_key_id)

  @doc """
  Returns the backblaze application key

      config :ex_backblaze, application_key: "your application key"
  """
  def application_key, do: from_env(:ex_backblaze, :application_key_id)

  @doc """
  A light wrapper around `Application.get_env/2`, providing automatic support for
  `{:system, "VAR"}` tuples.
  """
  def from_env(otp_app, key, default \\ nil)

  def from_env(otp_app, key, default) do
    otp_app
    |> Application.get_env(key, default)
    |> read_from_system(default)
  end

  defp read_from_system({:system, env}, default), do: System.get_env(env) || default
  defp read_from_system(value, _default), do: value
end
