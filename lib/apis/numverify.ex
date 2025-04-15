defmodule OliBot.Numverify do
  @numverify_base_url "http://apilayer.net/api/validate"
  @numverify_api_key System.get_env("NUMVERIFY_API_TOKEN")
  @country_code "BR"

  def validar_numero(numero) do
    url = "#{@numverify_base_url}?access_key=#{@numverify_api_key}&number=#{numero}&country_code=#{@country_code}&format=1"

    IO.puts(url)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"valid" => validacao, "international_format" => celular, "location" => localizacao}} ->
            {:ok, validacao, celular, localizacao}

          {:ok, _unexpected_response} ->
            {:error, "Resposta inesperada da API"}

          {:error, reason} ->
            {:error, "Erro ao decodificar JSON: #{reason}"}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Erro ao buscar informações: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Erro de conexão: #{reason}"}
    end
  end
end
