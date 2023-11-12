defmodule ExBackblaze.Tokens do
  @authorize "b2_authorize_account"
  @get_download_authorization "b2_get_download_authorization"
  @get_upload_part_url "b2_get_upload_part_url"
  @get_upload_url "b2_get_upload_url"

  @base_auth_url "https://api.backblazeb2.com"

  @moduledoc """
  Used to authorize use of B2 API. Returns an authorization token that can be used for account-level operations, and a URL that should be used as the base URL for subsequent API calls.

  Endpoints:
    * `#{@authorize}`
    * `#{@get_download_authorization}`
    * `#{@get_upload_part_url}`
    * `#{@get_upload_url}`
  """

  defmodule Token do
    defstruct absoluteMinimumPartSize: nil,
              accountId: nil,
              allowed: %{},
              apiUrl: nil,
              authorizationToken: nil,
              downloadUrl: nil,
              recommendedPartSize: nil,
              s3ApiUrl: nil

    @type t :: %__MODULE__{
            absoluteMinimumPartSize: integer(),
            accountId: String.t(),
            allowed: map(),
            apiUrl: String.t(),
            authorizationToken: String.t(),
            downloadUrl: String.t(),
            recommendedPartSize: integer(),
            s3ApiUrl: String.t()
          }
  end

  defmodule DownloadToken do
    defstruct bucketId: nil,
              fileNamePrefix: nil,
              authorizationToken: nil

    @type t :: %__MODULE__{
            bucketId: String.t(),
            fileNamePrefix: String.t(),
            authorizationToken: String.t()
          }
  end

  defmodule UploadToken do
    defstruct fileId: nil,
              uploadUrl: nil,
              authorizationToken: nil

    @type t :: %__MODULE__{
            fileId: String.t(),
            uploadUrl: String.t(),
            authorizationToken: String.t()
          }
  end

  alias ExBackblaze.Api.Request
  alias ExBackblaze.Tokens.Token
  alias ExBackblaze.Helpers
  alias ExBackblaze.Api

  @doc """
  GET /#{@authorize}

  Returns a token which includes `apiUrl` and `authorizationToken` which should be used with all subsequent requests

  ## Required Params

    * `application_key_id`
    * `application_key`

  ## Examples

      iex> ExBackblaze.Tokens.authorize("keyid", "key")
      {:ok, %Token{}}
  """
  @spec authorize(binary, binary) :: {:ok, Token.t()}
  def authorize(application_key_id, application_key) do
    authorize_url = "#{@base_auth_url}/#{Api.api_version()}/#{@authorize}"

    headers = [
      Authorization: "Basic " <> Base.url_encode64(application_key_id <> ":" <> application_key)
    ]

    opts = [method: :get, url: authorize_url, headers: headers]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> IO.inspect()
      |> Api.request()
      |> Api.handle_response()

    token =
      body
      |> to_token_struct(Token)

    {:ok, token}
  end

  @doc """
  POST /#{@get_download_authorization}

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_get_download_authorization.html

  ## Examples

      iex> ExBackblaze.Tokens.authorize([Authorization: "authtoken"], [bucketId: "bucketid", fileNamePrefix: "public", validDurationInSeconds: "1000"])
      {:ok, %Token{}}
  """
  @spec get_download_authorization(keyword(), keyword()) :: {:ok, ExBackblaze.Tokens.DownloadToken.t()}
  def get_download_authorization(headers, body) do
    get_download_authorization_url =
      "#{@base_auth_url}/#{Api.api_version()}/#{@get_download_authorization}"

    opts = [method: :post, url: get_download_authorization_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    token =
      body
      |> to_token_struct(DownloadToken)

    {:ok, token}
  end

  @doc """
  POST /#{@get_upload_part_url}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_get_upload_part_url.html
  """
  @spec get_upload_part_url(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) :: {:ok, ExBackblace.Tokens.UploadToken.t()}
  def get_upload_part_url(%Token{apiUrl: api_url}, headers, body) do
    get_upload_part_url_url = "#{api_url}/#{Api.api_version}/#{@get_upload_part_url}"

    opts = [method: :post, url: get_upload_part_url_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    token =
      body
      |> to_token_struct(UploadToken)

    {:ok, token}
  end

  @doc """
  POST /#{@get_upload_url}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_get_upload_url.html
  """
  @spec get_upload_url(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) :: {:ok, ExBackblace.Tokens.UploadToken.t()}
  def get_upload_url(%Token{apiUrl: api_url}, headers, body) do
    get_upload_url_url = "#{api_url}/#{Api.api_version}/#{@get_upload_url}"

    opts = [method: :post, url: get_upload_url_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    token =
      body
      |> to_token_struct(UploadToken)

    {:ok, token}
  end

  defp to_token_struct(json_body, token_type) do
    Helpers.get_struct(json_body, token_type)
  end
end
