defmodule OliBot.Cuttly do
  @cuttly_base_url "https://cutt.ly/api/api.php?key="
  @cuttly_api_key System.get_env("CUTTLY_API_TOKEN")

  def shorten_url(link) do

    url = "#{@cuttly_base_url}#{@cuttly_api_key}&short=#{link}"

    IO.puts(url)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"url" => %{"shortLink" => short_link}}} ->
            {:ok, short_link}

        _ ->
          {:error, "Erro ao decodificar a resposta da API"}
          end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Erro ao encurtar link: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Erro de conexão: #{(reason)}"}
    end
  end

end
