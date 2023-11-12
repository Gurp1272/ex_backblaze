defmodule ExBackblaze.Files do
  @cancel_large_file "b2_cancel_large_file"
  @copy_file "b2_copy_file"
  @delete_file_version "b2_delete_file_version"
  @finish_large_file "b2_finish_large_file"
  @get_file_info "b2_get_file_info"
  @list_file_names "b2_list_file_names"
  @list_file_versions "b2_list_file_versions"
  @start_large_file "b2_start_large_file"
  @hide_file "b2_hide_file"
  @list_unfinished_large_files "b2_list_unfinished_large_files"
  @upload_part "b2_upload_part"
  @upload_file "b2_upload_file"
  @copy_part "b2_copy_part"
  @list_parts "b2_list_parts"
  @update_file_legal_hold "b2_update_file_legal_hold"
  @update_file_retention "b2_update_file_retention"

  @moduledoc """
  Endpoints:
    * `#{@cancel_large_file}`
    * `#{@copy_file}`
    * `#{@delete_file_version}`
    * `#{@finish_large_file}`
    * `#{@get_file_info}`
    * `#{@list_file_names}`
    * `#{@list_file_versions}`
    * `#{@start_large_file}`
    * `#{@hide_file}`
    * `#{@list_unfinished_large_files}`
    * `#{@upload_part}`
    * `#{@upload_file}`
    * `#{@copy_part}`
    * `#{@list_parts}`
    * `#{@update_file_legal_hold}`
    * `#{@update_file_retention}`
  """

  defmodule File do
    defstruct accountId: nil,
              action: nil,
              bucketId: nil,
              contentLength: nil,
              contentSha1: nil,
              contentMd5: nil,
              contentType: nil,
              fileId: nil,
              fileInfo: nil,
              fileName: nil,
              fileBinary: nil,
              fileRetention: nil,
              legalHold: nil,
              replicationStatus: nil,
              serverSideEncryption: nil,
              uploadTimestamp: nil,
              partNumber: nil

    @type t :: %__MODULE__{
            accountId: String.t(),
            action: String.t(),
            bucketId: String.t(),
            contentLength: integer(),
            contentSha1: String.t(),
            contentMd5: String.t(),
            contentType: String.t(),
            fileId: String.t(),
            fileInfo: map(),
            fileName: String.t(),
            fileBinary: bitstring(),
            fileRetention: map(),
            legalHold: map(),
            replicationStatus: String.t(),
            serverSideEncryption: map(),
            uploadTimestamp: integer(),
            partNumber: integer()
          }
  end

  alias ExBackblaze.Api.Request
  alias ExBackblaze.Files.File
  alias ExBackblaze.Tokens.Token
  alias ExBackblaze.Helpers
  alias ExBackblaze.Api

  @doc """
  POST /#{@list_file_names}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_list_file_names.html

  Examples

      iex> ExBackblaze.Files.list_file_names(token, [Authorization: "authtoken"], [bucketId: "bucketid"])
      {:ok, %{files: list, next_file_name: string}}

  """
  @spec list_file_names(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, %{files: list, next_file_name: any}}
  def list_file_names(%Token{apiUrl: api_url}, headers, body) do
    list_file_names_url = "#{api_url}/#{Api.api_version()}/#{@list_file_names}"

    opts = [method: :post, url: list_file_names_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    files =
      body
      |> response()

    {:ok, files}
  end

  @doc """
  POST /#{@cancel_large_file}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_cancel_large_file.html
  """
  @spec cancel_large_file(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, ExBackblaze.Files.File.t()}
  def cancel_large_file(%Token{apiUrl: api_url}, headers, body) do
    cancel_large_file_url = "#{api_url}/#{Api.api_version()}/#{@cancel_large_file}"

    opts = [method: :post, url: cancel_large_file_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      body
      |> to_file_struct()

    {:ok, file}
  end

  @doc """
  POST /#{@copy_file}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_copy_file.html
  """
  @spec copy_file(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, ExBackblaze.Files.File.t()}
  def copy_file(%Token{apiUrl: api_url}, headers, body) do
    copy_file_url = "#{api_url}/#{Api.api_version()}/#{@copy_file}"

    opts = [method: :post, url: copy_file_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      body
      |> to_file_struct()

    {:ok, file}
  end

  @doc """
  POST /#{@delete_file_version}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_delete_file_version.html
  """
  @spec delete_file_version(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, ExBackblaze.Files.File.t()}
  def delete_file_version(%Token{apiUrl: api_url}, headers, body) do
    delete_file_version_url = "#{api_url}/#{Api.api_version()}/#{@delete_file_version}"

    opts = [method: :post, url: delete_file_version_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      body
      |> to_file_struct()

    {:ok, file}
  end

  @doc """
  POST /#{@finish_large_file}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_finish_large_file.html

  ## Examples

      iex> ExBackblaze.Files.finish_large_file(token, [Authorization: "authtoken"], [fileId: "fileid", partSha1Array: ["checksum", "checksum"]])
      {:ok, %ExBackblaze.Files.File{}}
  """
  @spec finish_large_file(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, ExBackblaze.Files.File.t()}
  def finish_large_file(%Token{apiUrl: api_url}, headers, body) do
    finish_large_file_url = "#{api_url}/#{Api.api_version()}/#{@finish_large_file}"

    opts = [method: :post, url: finish_large_file_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      body
      |> to_file_struct()

    {:ok, file}
  end

  @doc """
  POST /#{@get_file_info}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_get_file_info.html
  """
  @spec get_file_info(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, ExBackblaze.Files.File.t()}
  def get_file_info(%Token{apiUrl: api_url}, headers, body) do
    get_file_info_url = "#{api_url}/#{Api.api_version()}/#{@get_file_info}"

    opts = [method: :post, url: get_file_info_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      body
      |> to_file_struct()

    {:ok, file}
  end

  @doc """
  POST /#{@list_file_versions}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_list_file_versions.html
  """
  @spec list_file_versions(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, %{files: list, next_file_id: any, next_file_name: any}}
  def list_file_versions(%Token{apiUrl: api_url}, headers, body) do
    list_file_versions_url = "#{api_url}/#{Api.api_version()}/#{@list_file_versions}"

    opts = [method: :post, url: list_file_versions_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    files =
      body
      |> response()

    {:ok, files}
  end

  @doc """
  POST /#{@start_large_file}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_start_large_file.html
  """
  @spec start_large_file(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, ExBackblaze.Files.File.t()}
  def start_large_file(%Token{apiUrl: api_url}, headers, body) do
    start_large_file_url = "#{api_url}/#{Api.api_version()}/#{@start_large_file}"

    opts = [method: :post, url: start_large_file_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      body
      |> to_file_struct()

    {:ok, file}
  end

  @doc """
  POST /#{@hide_file}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_hide_file.html
  """
  @spec hide_file(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, ExBackblaze.Files.File.t()}
  def hide_file(%Token{apiUrl: api_url}, headers, body) do
    hide_file_url = "#{api_url}/#{Api.api_version()}/#{@hide_file}"

    opts = [method: :post, url: hide_file_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      body
      |> to_file_struct()

    {:ok, file}
  end

  @doc """
  POST /#{@list_unfinished_large_files}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_list_unfinished_large_files.html
  """
  @spec list_unfinished_large_files(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) ::
          {:ok, %{files: list, next_file_id: any}}
  def list_unfinished_large_files(%Token{apiUrl: api_url}, headers, body) do
    list_unfinished_large_files_url =
      "#{api_url}/#{Api.api_version()}/#{@list_unfinished_large_files}"

    opts = [method: :post, url: list_unfinished_large_files_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    files =
      body
      |> response()

    {:ok, files}
  end

  @doc """
  POST /#{@upload_part}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_upload_part.html
  """
  @spec upload_part(ExBackblaze.Tokens.Token.t(), keyword(), binary()) ::
          {:ok, ExBackblaze.Files.File.t()}
  def upload_part(%Token{apiUrl: api_url}, headers, body) do
    upload_part_url = "#{api_url}/#{Api.api_version()}/#{@upload_part}"

    opts = [method: :post, url: upload_part_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      body
      |> to_file_struct()

    {:ok, file}
  end

  @doc """
  POST /#{@upload_file}

  ## Required Params

    * `%Token{}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_upload_file.html

  """
  @spec upload_file(ExBackblaze.Tokens.Token.t(), keyword(), binary()) :: {:ok, ExBackblaze.Files.File.t()}
  def upload_file(%Token{apiUrl: api_url}, headers, body) do
    upload_file_url = "#{api_url}/#{Api.api_version}/#{@upload_file}"

    opts = [method: :post, url: upload_file_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      body
      |> to_file_struct()

    {:ok, file}
  end

  @doc """
  POST /#{@copy_part}

  ## Required Params

    * `%Token{apiUrl: api_url}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_copy_part.html
  """
  @spec copy_part(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) :: {:ok, ExBackblaze.Files.File.t()}
  def copy_part(%Token{apiUrl: api_url}, headers, body) do
    copy_part_url = "#{api_url}/#{Api.api_version}/#{@copy_part}"

    opts = [method: :post, url: copy_part_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      body
      |> to_file_struct()

    {:ok, file}
  end

  @doc """
  POST /#{@list_parts}

  ## Required Params

    * `%Token{apiUrl: api_url}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_list_parts.html
  """
  @spec list_parts(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) :: {:ok, %{parts: list, next_part_number: any}}
  def list_parts(%Token{apiUrl: api_url}, headers, body) do
    list_parts_url = "#{api_url}/#{Api.api_version}/#{@list_parts}"

    opts = [method: :post, url: list_parts_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      body
      |> response()

    {:ok, file}
  end

  @doc """
  POST /#{@update_file_legal_hold}

  ## Required Params

    * `%Token{apiUrl: api_url}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_update_file_legal_hold.html
  """
  @spec update_file_legal_hold(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) :: {:ok, ExBackblaze.Files.File.t()}
  def update_file_legal_hold(%Token{apiUrl: api_url}, headers, body) do
    update_file_legal_hold_url = "#{api_url}/#{Api.api_version}/#{@update_file_legal_hold}"

    opts = [method: :post, url: update_file_legal_hold_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      body
      |> to_file_struct()

    {:ok, file}
  end

  @doc """
  POST /#{@update_file_retention}

  ## Required Params

    * `%Token{apiUrl: api_url}`

  ## See docs:
  https://www.backblaze.com/b2/docs/b2_update_file_retention.html
  """
  @spec update_file_retention(ExBackblaze.Tokens.Token.t(), keyword(), keyword()) :: {:ok, ExBackblaze.Files.File.t()}
  def update_file_retention(%Token{apiUrl: api_url}, headers, body) do
    update_file_retention_url = "#{api_url}/#{Api.api_version}/#{@update_file_retention}"

    opts = [method: :post, url: update_file_retention_url, headers: headers, body: body]

    {:ok, body} =
      Request
      |> struct!(opts)
      |> Api.request()
      |> Api.handle_response()

    file =
      body
      |> to_file_struct()

    {:ok, file}
  end

  defp response(json_body) when is_binary(json_body) do
    map_body =
      json_body
      |> Helpers.decode_json()

    response(map_body)
  end

  defp response(%{parts: parts, nextPartNumber: next_part_number}) do
    files =
      parts
      |> Enum.map(fn key_map -> Helpers.to_struct(key_map, File) end)

    %{parts: files, next_part_number: next_part_number}
  end

  defp response(%{files: files, nextFileId: next_file_id, nextFileName: next_file_name}) do
    files =
      files
      |> Enum.map(fn key_map -> Helpers.to_struct(key_map, File) end)

    %{files: files, next_file_id: next_file_id, next_file_name: next_file_name}
  end

  defp response(%{files: files, nextFileName: next_file_name}) do
    files =
      files
      |> Enum.map(fn key_map -> Helpers.to_struct(key_map, File) end)

    %{files: files, next_file_name: next_file_name}
  end

  defp response(%{files: files, nextFileId: next_file_id}) do
    files =
      files
      |> Enum.map(fn key_map -> Helpers.to_struct(key_map, File) end)

    %{files: files, next_file_id: next_file_id}
  end

  defp to_file_struct(json_body), do: Helpers.get_struct(json_body, File)
end
