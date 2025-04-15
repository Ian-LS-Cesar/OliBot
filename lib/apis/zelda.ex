defmodule OliBot.Zelda do
  @zelda_url "https://zelda.fanapis.com/api/games?name="

  def fetch_zelda(jogo) do
    url = "#{@zelda_url}#{URI.encode(jogo)}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"data" => [first_game | _]}} ->
            %{
              "name" => nome,
              "description" => descricao,
              "released_date" => lancamento
            } = first_game

            {:ok, nome, descricao, lancamento}

          {:ok, %{"data" => []}} ->
            {:error, "Nenhum jogo encontrado com o nome fornecido."}

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
