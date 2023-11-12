defmodule ExBackblaze.Helpers do
  def get_struct(json, module) when is_binary(json) do
    json
    |> decode_json()
    |> to_struct(module)
  end

  def decode_json(json), do: json |> Jason.decode!(keys: :atoms)

  def to_struct(map, module), do: struct!(module, map)
end
