defmodule Elastic.AWS do

  @moduledoc false
  def enabled? do
    settings()[:enabled]
  end

  def sign_headers(method, url) do
    AWSAuth.sign_authorization_header(
      settings().access_key_id,
      settings().secret_access_key,
      to_string(method),
      url,
      settings().region,
      "es"
    )
    |> Enum.into(%{})
    |> build_signed_headers
  end

  # DELETE requests do not support headers
  defp process_headers(:delete, _), do: %{}

  defp process_headers(_method, headers) do
    for {k, v} <- headers,
      into: %{},
      do: {to_string(k), to_string(v)}
  end

  defp build_signed_headers(headers) do
    %{
      "authorization" => authorization,
      "x-amz-date" => x_amz_date,
      "x-amz-content-sha256" => x_amz_content_sha256
    } = headers
    ["Authorization": authorization, "X-Amz-Date": x_amz_date, "X-Amz-Content-Sha256": x_amz_content_sha256]
  end

  defp settings do
    Application.get_env(:elastic, :aws)
  end
end
