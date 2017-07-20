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
    |> build_signed_headers
  end

  defp build_signed_headers(headers) do
    headers
    |> Enum.into(%{})
    |> Enum.map(fn({key, value}) -> {:"#{key}", value} end)
  end

  defp settings do
    Application.get_env(:elastic, :aws)
  end
end
