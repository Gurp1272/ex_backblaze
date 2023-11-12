defmodule ExBackblaze.Buckets do
  @create_bucket "b2_create_bucket"
  @delete_bucket "b2_delete_bucket"
  @list_buckets "b2_list_buckets"
  @update_bucket "b2_update_bucket"

  @moduledoc """
  Endpoints:
    * `#{@create_bucket}`
    * `#{@delete_bucket}`
    * `#{@list_buckets}`
    * `#{@update_bucket}`
  """
  defmodule Bucket do
    defstruct accountId: nil,
              bucketId: nil,
              bucketName: nil,
              bucketType: nil,
              bucketInfo: %{},
              corsRules: [],
              fileLockConfiguration: %{},
              defaultServerSideEncryption: %{},
              lifecycleRules: [],
              replicationConfiguration: nil,
              revision: nil,
              options: []

    @type t :: %__MODULE__{
            accountId: String.t(),
            bucketId: String.t(),
            bucketName: String.t(),
            bucketType: String.t(),
            bucketInfo: map(),
            corsRules: list(),
            fileLockConfiguration: map(),
            defaultServerSideEncryption: map(),
            lifecycleRules: list(),
            replicationConfiguration: any(),
            revision: integer(),
            options: list()
          }
  end

  alias Mint.HTTP1.Request
  alias ExBackblaze.Buckets.Bucket
  alias ExBackblaze.Tokens.Token
  alias ExBackblaze.Helpers
  alias ExBackblaze.Api

  @doc """
  POST /#{@create_bucket}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_create_bucket.html
  """
  @spec create_bucket(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, ExBackblaze.Buckets.Bucket.t()}
  def create_bucket(%Token{apiUrl: api_url}, headers, body) do
    create_bucket_url = "#{api_url}/#{Api.api_version()}/#{@create_bucket}"

    opts = [method: :post, url: create_bucket_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    bucket =
      body
      |> to_bucket_struct()

    {:ok, bucket}
  end

  @doc """
  POST /#{@delete_bucket}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_delete_bucket.html
  """
  @spec delete_bucket(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) :: {:ok, ExBackblaze.Buckets.Bucket.t()}
  def delete_bucket(%Token{apiUrl: api_url}, headers, body) do
    delete_bucket_url = "#{api_url}/#{Api.api_version()}/#{@delete_bucket}"

    opts = [method: :post, url: delete_bucket_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    bucket =
      body
      |> to_bucket_struct()

    {:ok, bucket}
  end

  @doc """
  POST /#{@list_buckets}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_list_buckets.html
  """
  @spec list_buckets(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) :: {:ok, %{buckets: list}}
  def list_buckets(%Token{apiUrl: api_url}, headers, body) do
    list_buckets_url = "#{api_url}/#{Api.api_version}/#{@list_buckets}"

    opts = [method: :post, url: list_buckets_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    buckets =
      body
      |> response()

    {:ok, buckets}
  end

  @doc """
  POST /#{@update_bucket}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_update_bucket.html
  """
  @spec update_bucket(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) :: {:ok, ExBackblaze.Buckets.Bucket.t()}
  def update_bucket(%Token{apiUrl: api_url}, headers, body) do
    update_bucket_url = "#{api_url}/#{Api.api_version}/#{@update_bucket}"

    opts = [method: :post, url: update_bucket_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    bucket =
      body
      |> to_bucket_struct()

    {:ok, bucket}
  end

  defp response(json_body) when is_binary(json_body) do
    map_body =
      json_body
      |> Helpers.decode_json()

    response(map_body)
  end

  defp response(%{buckets: buckets}) do
    buckets =
      buckets
      |> Enum.map(fn key_map -> Helpers.to_struct(key_map, Bucket) end)

    %{buckets: buckets}
  end

  defp to_bucket_struct(json_body), do: Helpers.get_struct(json_body, Bucket)
end
