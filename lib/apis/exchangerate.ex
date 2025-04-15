defmodule OliBot.ExchangeRate do
  @exchangerate_base_url "https://v6.exchangerate-api.com/v6/"
  @exchangerate_api_key System.get_env("EXCHANGERATE_API_TOKEN")

  def fetch_exchange(moeda) do
    url = "#{@exchangerate_base_url}#{@exchangerate_api_key}/latest/BRL"

    IO.puts(url)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"conversion_rates" => conversao}} ->
            case Map.fetch(conversao, moeda) do
              {:ok, valor} ->
                {:ok, valor}

              :error ->
                {:error, "Moeda #{moeda} não encontrada"}
            end

          {:error, reason} ->
            {:error, "Erro ao decodificar JSON: #{reason}"}
        end
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Erro ao buscar taxa de câmbio: HTTP #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Erro de conexão: #{reason}"}
    end
  end
end
