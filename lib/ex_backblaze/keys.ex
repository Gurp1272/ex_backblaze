defmodule ExBackblaze.Keys do
  @create_key "b2_create_key"
  @delete_key "b2_delete_key"
  @list_keys "b2_list_keys"

  @moduledoc """
  Endpoints:
    * `#{@create_key}`
    * `#{@delete_key}`
    * `#{@list_keys}`
  """

  defmodule Key do
    @enforce_keys [:accountId, :applicationKeyId, :capabilities, :keyName]

    defstruct accountId: nil,
              applicationKey: nil,
              applicationKeyId: nil,
              bucketId: nil,
              capabilities: [],
              expirationTimestamp: nil,
              keyName: nil,
              namePrefix: nil,
              options: []

    @type t :: %__MODULE__{
            accountId: String.t(),
            applicationKey: String.t(),
            applicationKeyId: String.t(),
            bucketId: String.t(),
            capabilities: list(String.t()),
            expirationTimestamp: integer(),
            keyName: String.t(),
            namePrefix: String.t(),
            options: list(String.t())
          }
  end

  alias ExBackblaze.Api.Request
  alias ExBackblaze.Keys.Key
  alias ExBackblaze.Tokens.Token
  alias ExBackblaze.Helpers
  alias ExBackblaze.Api

  @doc """
  POST /#{@create_key}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_create_key.html

  ## Examples

      iex> ExBackblaze.Keys.create_key(token, [Authorization: "authtoken"], [accountId: "id", capabilities: ["readFiles", "writeFiles"], keyName: "thename"])
      {:ok, ExBackblaze.Keys.Key{}}
  """
  @spec create_key(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, ExBackblaze.Keys.Key.t()}
  def create_key(%Token{apiUrl: api_url}, headers, body) do
    create_key_url = "#{api_url}/#{Api.api_version()}/#{@create_key}"

    opts = [method: :post, url: create_key_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    key =
      body
      |> to_key_struct()

    {:ok, key}
  end

  @doc """
  POST /#{@delete_key}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_delete_key.html

  ## Examples

      iex> ExBackblaze.Keys.delete_key(token, [Authorization: "authtoken"], [applicationKeyId: "appkeyid"])
      {:ok, ExBackblaze.Keys.key{}}
  """
  @spec delete_key(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, ExBackblaze.Keys.Key.t()}
  def delete_key(%Token{apiUrl: api_url}, headers, body) do
    delete_key_url = "#{api_url}/#{Api.api_version()}/#{@delete_key}"

    opts = [method: :post, url: delete_key_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    key =
      body
      |> to_key_struct()

    {:ok, key}
  end

  @doc """
  GET /#{@list_keys}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_list_keys.html

  ## Examples

      iex> ExBackblaze.Keys.list_keys(token, [Authorization: "authtoken"], [accountId: "accid", maxKeyCount: 100])
      {:ok, %{keys: list, next_application_key_id: string}}
  """
  @spec list_keys(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, %{keys: list, next_application_key_id: any}}
  def list_keys(%Token{apiUrl: api_url, accountId: account_id}, headers, opts) do
    list_keys_url = "#{api_url}/#{Api.api_version()}/#{@list_keys}?accountId=#{account_id}"

    opts = [method: :get, url: list_keys_url, headers: headers, opts: opts]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    keys =
      body
      |> response()

    {:ok, keys}
  end

  defp response(json_body) when is_binary(json_body) do
    map_body =
      json_body
      |> Helpers.decode_json()

    response(map_body)
  end

  defp response(%{keys: keys, nextApplicationKeyId: next_application_key_id}) do
    keys =
      keys
      |> Enum.map(fn key_map -> Helpers.to_struct(key_map, Key) end)

    %{keys: keys, next_application_key_id: next_application_key_id}
  end

  defp to_key_struct(json_body), do: Helpers.get_struct(json_body, Key)
end
