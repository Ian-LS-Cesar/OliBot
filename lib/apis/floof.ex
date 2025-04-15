defmodule OliBot.Floof do
  @floof_api_url "https://randomfox.ca/floof/"


  def fetch_raposa() do
    url = "#{@floof_api_url}"

    IO.puts(url)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"image" => image_url}} ->
            {:ok, %{image: image_url}}
          _ ->
            {:error, "Erro ao decodificar a resposta da API"}
          end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Erro ao mostrar imagem: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Erro de conexão: #{(reason)}"}
    end
  end
end
