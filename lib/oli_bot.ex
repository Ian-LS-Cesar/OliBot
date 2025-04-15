defmodule OliBot do
  use Nostrum.Consumer
  alias Nostrum.Api
  alias OliBot.Weatherstack
  alias OliBot.Cuttly
  alias OliBot.Floof
  alias OliBot.ExchangeRate
  alias OliBot.Numverify
  alias OliBot.Qrcode
  alias OliBot.Zelda

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    cond do

      #Comando de Teste
      String.starts_with?(msg.content, "!comandos") ->
        listar_comandos(msg.channel_id)

      #Comando de Clima
      String.starts_with?(msg.content, "!clima ") ->
        cidade = String.trim_leading(msg.content, "!clima ")
        Weatherstack.fetch_clima(cidade)
        |> send_clima_response(msg.channel_id)

      #Comando de Raposa
      String.starts_with?(msg.content, "!raposa") ->
        Floof.fetch_raposa()
        |> send_raposa_response(msg.channel_id)

      #Comando Validar Número
      String.starts_with?(msg.content, "!validar_numero ") ->
        numero = String.trim_leading(msg.content, "!validar_numero ")
        Numverify.validar_numero("#{numero}")
        |> send_numero_response(msg.channel_id)

      #Comando Encurtador de Link
      String.starts_with?(msg.content, "!encurtar ") ->
        link = String.trim_leading(msg.content, "!encurtar ")
        Cuttly.shorten_url(link)
        |> send_cuttly_response(msg.channel_id)

      #Zelda
      String.starts_with?(msg.content, "!zelda ") ->
        jogo = String.trim_leading(msg.content, "!zelda ")
        Zelda.fetch_zelda(jogo)
        |> send_zelda_response(msg.channel_id)

      #QRCode
      String.starts_with?(msg.content, "!qrcode ") ->
        texto = String.trim_leading(msg.content, "!qrcode ")
        Qrcode.fetch_qrcode(texto)
        |> send_qrcode_response(msg.channel_id)

      #Cotação
      String.starts_with?(msg.content, "!cotacao ") ->
        moeda = String.trim_leading(msg.content, "!cotacao ")
        ExchangeRate.fetch_exchange(moeda)
        |> send_conversion_response(msg.channel_id, moeda)
      true ->
        :ignore
    end
  end
  #Listar Comandos
  defp listar_comandos(channel_id) do
    response = "> ## ***Lista de Comandos do OliBot*** :cat:
    > - *!clima (Cidade)* -> Diz a temperatura e clima atual da cidade :thermometer:
    > - *!cotacao (Sigla da Moeda)* -> Imprime o valor atual de câmbio da moeda estipulada com o Real :money_with_wings:
    > - *!encurtar (Link)* -> Faz o encurtamento de um link enviado pelo usuário :link:
    > - *!raposa* -> Imagens aleatória de raposas :fox:
    > - *!validar_numero (Número)* -> Verifica a validade de um numero de celular :mobile_phone:
    > - *!qrcode (Texto)* -> Transforma texto/link em um QR Code :ballot_box:
    > - *!zelda (Jogo)* -> Imprime descrição e data de lançamento de um jogo The Legend of Zelda :crossed_swords:
    > -# Criado por: Ian Lucas S. César"
    Api.Message.create(channel_id, response)
  end

  #Clima Response
  defp send_clima_response({:ok, local, temperatura, codigo}, channel_id) do

    response = "> O clima em #{local} é de *#{temperatura}°C* com clima de *#{traduzir_codigo_clima(codigo)}* :thermometer:"
    Api.Message.create(channel_id, response)
  end

  defp send_clima_response({:error, reason}, channel_id) do
    response = "Desculpe, não consegui obter as informações do clima.\nMotivo: #{reason}"
    Api.Message.create(channel_id, response)
  end

  defp traduzir_codigo_clima(codigo) do
    case codigo do
      113 -> "Céu limpo"
      116 -> "Parcialmente nublado"
      119 -> "Nublado"
      122 -> "Encoberto"
      143 -> "Neblina"
      176 -> "Possibilidade de chuva irregular"
      179 -> "Possibilidade de neve irregular"
      182 -> "Possibilidade de neve molhada irregular"
      185 -> "Possibilidade de chuvisco gelado irregular"
      200 -> "Possibilidade de trovoada"
      227 -> "Rajadas de vento com neve"
      230 -> "Nevasca"
      248 -> "Nevoeiro"
      260 -> "Nevoeiro gelado"
      263 -> "Chuvisco irregular"
      266 -> "Chuvisco"
      281 -> "Chuvisco gelado"
      284 -> "Chuvisco forte gelado"
      293 -> "Chuva fraca irregular"
      296 -> "Chuva fraca"
      299 -> "Períodos de chuva moderada"
      302 -> "Chuva moderada"
      305 -> "Períodos de chuva forte"
      308 -> "Chuva forte"
      311 -> "Chuva fraca e gelada"
      _ -> "Código de clima desconhecido"
    end
  end

  #Raposa Response
  defp send_raposa_response({:ok, %{image: imagem}}, channel_id) do
    embed = %{
      title: "Raposa :fox:",
      image: %{url: imagem}
    }

    Api.Message.create(channel_id, embed: embed)
  end

  defp send_raposa_response({:error, reason}, channel_id) do
    response = "Desculpe, não consegui enviar uma imagem de raposa.\nMotivo: #{reason}"
    Api.Message.create(channel_id, response)
  end

  #Numero Response

  defp send_numero_response({:ok, validacao, celular, localizacao}, channel_id) do
    response =
      if validacao do
        "> O número #{celular} :telephone_receiver:  é ***válido*** :white_check_mark:\nLocal: #{localizacao}"
      else
        "> O número #{celular} :telephone_receiver:  é ***inválido*** :x:"
      end

    Api.Message.create(channel_id, response)
  end

  defp send_numero_response({:error, reason}, channel_id) do
    response = "Desculpe, não foi possível fazer a validação.\nMotivo: #{reason}"
    Api.Message.create(channel_id, response)
  end

  #Cuttly Response

  defp send_cuttly_response({:ok, link_encurtado}, channel_id) do
    response = "> Seu link foi encurtado :scissors:: <#{link_encurtado}>"
    Api.Message.create(channel_id, response)
  end

  defp send_cuttly_response({:error, reason}, channel_id) do
    response = "Desculpe, não foi possível encurtar o link.\nMotivo: #{reason}"
    Api.Message.create(channel_id, response)
  end

  #Zelda Response

  defp send_zelda_response({:ok, nome, descricao, lancamento}, channel_id) do
    response = "> **Game:** *#{nome}*
    > **Release Date:**#{lancamento}
    > **Description:** `#{descricao}`"
    Api.Message.create(channel_id, response)
  end

  defp send_zelda_response({:error, reason}, channel_id) do
    response = "Desculpe, não foi possível encurtar o jogo pesquisado.\nMotivo: #{reason}"
    Api.Message.create(channel_id, response)
  end

  #QRCode Response

  defp send_qrcode_response({:ok, qrcode}, channel_id) do
    response = "#{qrcode}"
    Api.Message.create(channel_id, response)
  end

  #Cotacao Response

  defp send_conversion_response({:ok, valor}, channel_id, moeda) do
    response = "**BRL** *$1.00*   :arrow_right:   *$#{Float.round(valor, 2)}* **#{moeda}**"
    Api.Message.create(channel_id, response)
  end

  defp send_conversion_response({:error, reason}, channel_id, _moeda) do
    response = "Desculpe, não foi possível fazer a conversão.\nMotivo: #{reason}"
    Api.Message.create(channel_id, response)
  end

end
