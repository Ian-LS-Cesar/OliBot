defmodule OliBot.Weatherstack do
  @weatherstack_api_url "http://api.weatherstack.com/current"
  @weatherstack_api_key System.get_env("WEATHERSTACK_API_TOKEN")

  def fetch_clima(cidade) do
    url = "#{@weatherstack_api_url}?access_key=#{@weatherstack_api_key}&query=#{URI.encode(cidade)}"

    IO.puts(url)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"current" => clima, "location" => local}} ->
            {:ok, local["name"], clima["temperature"], clima["weather_code"]}

          _ ->
            {:error, "Erro ao decodificar a resposta da API"}
          end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Erro ao buscar clima: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Erro de conexão: #{(reason)}"}
    end
  end
end
