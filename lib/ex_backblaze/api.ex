defmodule ExBackblaze.Api do
  @moduledoc false
  @doc """
  API responses are trafficked through here -- handle_response/1

  Outgoing requests are created here -- request/1
  """
  require Logger

  defmodule Request do
    @moduledoc false
    defstruct method: nil,
              url: nil,
              opts: nil,
              headers: nil,
              body: nil

    @type method :: :get | :post
    @type url :: binary | any
    @type opts :: keyword | any
    @type headers :: [{atom, binary}] | [{binary, binary}]
    @type body :: keyword | any

    @type t :: %__MODULE__{
            method: method,
            url: url,
            opts: opts,
            headers: headers,
            body: body
          }
  end

  alias ExBackblaze.Api.Request

  @api_version "b2api/v2"

  @spec request(ExBackblaze.Api.Request.t()) :: {:ok, Finch.Response.t()}
  def request(%Request{method: :get} = request) do
    request
    |> process_url()
    |> process_headers()
    |> create_request()
    |> Finch.request(HTTPClient)
  end

  def request(%Request{method: :post} = request) do
    request
    |> process_url()
    |> process_headers()
    |> process_body()
    |> create_request()
    |> Finch.request(HTTPClient)
  end

  @doc """
  Handles bitstring response from file downloads
  """
  @spec handle_response({:ok, Finch.Response.t()}) ::
          {:error, any} | {:ok, binary()} | {:ok, bitstring()}
  def handle_response(
        {:ok,
         %Finch.Response{
           status: 200,
           body: <<rest::binary>> = body,
           headers: headers
         }}
      ) do
    case checksum_match?(headers, body) do
      true ->
        {:ok, rest}

      false ->
        Logger.error("checksum mismatch on download")
        {:error, :checksum_mismatch}
    end
  end

  def handle_response({:ok, %Finch.Response{status: 200} = response}) do
    {:ok, response.body}
  end

  def handle_response({:ok, %Finch.Response{status: status} = response}) do
    Logger.error("error #{status} -- #{response.body}")

    {:error, status}
  end

  def api_version, do: @api_version

  defp checksum_match?(headers, body) do
    [preexisting_sha] = for {"x-bz-content-sha1", value} <- headers, do: value

    downloaded_sha =
      :crypto.hash(:sha, body)
      |> Base.encode16()
      |> String.downcase()

    preexisting_sha == downloaded_sha
  end

  # Returns a %Finch.Request{}
  defp create_request(%Request{method: method, url: url, headers: headers, body: body}) do
    Finch.build(
      method,
      url,
      headers,
      body
    )
  end

  defp process_body(%Request{body: body} = request) do
    body =
      body
      |> Jason.encode!()

    request
    |> Map.put(:body, body)
  end

  # Converts [Authorization: "authtoken"] to ["Authorization": "authtoken"]
  defp process_headers(%Request{headers: headers} = request) do
    stringified_headers =
      headers
      |> Enum.map(fn {header, value} ->
        case is_atom(header) do
          true ->
            {Atom.to_string(header), value}

          false ->
            {header, value}
        end
      end)

    request
    |> Map.put(:headers, stringified_headers)
  end

  # Encodes opts as url query params
  defp process_url(%Request{url: url, opts: opts} = request) when not is_nil(opts) do
    opts =
      opts
      |> parse_opts()

    url =
      opts
      |> Enum.reduce(url, fn param, acc ->
        URI.append_query(URI.parse(acc), param)
        |> URI.to_string()
      end)

    request
    |> Map.put(:url, url)
  end

  defp process_url(%Request{} = request), do: request

  defp parse_opts(%Request{opts: opts} = request) do
    opts =
      opts
      |> Enum.map(fn {opt, value} -> "#{opt}=#{value}" end)

    request
    |> Map.put(:opts, opts)
  end
end
