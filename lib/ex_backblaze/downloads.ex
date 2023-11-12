defmodule ExBackblaze.Downloads do
  @download_file_by_id "b2_download_file_by_id"
  @download_file_by_name "b2_download_file_by_name"

  @moduledoc """
  Authorization is only required to access buckets with a `bucketType` of "allPrivate"

  The auth token must have the readFiles capability. This is required if the bucket containing the file is not public. It is optional for buckets that are public. Alternatively, a download authorization token obtained from b2_get_download_authorization can be used to access files whose names begin with the filename prefix that was used to generate the download authorization token.

  See: https://www.backblaze.com/b2/docs/buckets.html

  Endpoints:
    * `#{@download_file_by_id}`
    * `#{@download_file_by_name}`
  """
  alias ExBackblaze.Tokens.Token
  alias ExBackblaze.Api
  alias ExBackblaze.Api.Request
  alias ExBackblaze.Files.File
  alias ExBackblaze.Buckets.Bucket

  @doc """
  GET /#{@download_file_by_id}

  ## Required Params

  Required Params are interpolated into the request url

    * `%File{fileId: file_id}`
    * `%Token{downloadUrl: download_url}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_download_file_by_name.html

  ## Options

  opts are encoded as URL query params

  ## Examples

      iex> ExBackblaze.Downloads.download_file_by_id(token, file, [Authorization: "3_2016080_d943_dnld"])
      {:ok, ExBackblaze.Files.File{}}

  """
  @spec download_file_by_id(ExBackblaze.Tokens.Token.t(), ExBackblaze.Files.File.t(), any, any) ::
          {:ok, ExBackblaze.Files.File.t()}
  def download_file_by_id(
        %Token{downloadUrl: download_url},
        %File{fileId: file_id} = file,
        headers \\ [],
        opts \\ []
      ) do
    download_file_by_id_url =
      "#{download_url}/#{Api.api_version()}/#{@download_file_by_id}?fileId=#{file_id}"

    opts = [method: :get, url: download_file_by_id_url, opts: opts, headers: headers]

    {:ok, binary} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      file
      |> Map.put(:fileBinary, binary)

    {:ok, file}
  end

  @doc """
  GET /#{@download_file_by_name}

  ## Required Params

    * `%Token{downloadUrl: download_url}`
    * `%File{fileId: file_id}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_download_file_by_name.html

  ## Options

  opts are encoded as URL query params

  ## Examples

      iex> ExBackblaze.Downloads.download_file_by_name(token, bucket, file, [Authorization: "3_2016080_d943_dnld"])
      {:ok, ExBackblaze.Files.File{}}

  """
  @spec download_file_by_name(
          ExBackblaze.Tokens.Token.t(),
          ExBackblaze.Buckets.Bucket.t(),
          ExBackblaze.Files.File.t(),
          any,
          any
        ) :: {:ok, ExBackblaze.Files.File.t()}
  def download_file_by_name(
        %Token{downloadUrl: download_url},
        %Bucket{bucketName: bucket_name},
        %File{fileName: file_name} = file,
        headers \\ [],
        opts \\ []
      ) do
    download_file_by_name_url = "#{download_url}/file/#{bucket_name}/#{file_name}"

    opts = [method: :get, url: download_file_by_name_url, opts: opts, headers: headers]

    {:ok, binary} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      file
      |> Map.put(:fileBinary, binary)

    {:ok, file}
  end
end
