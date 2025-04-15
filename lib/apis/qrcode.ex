defmodule OliBot.Qrcode do

  @qrcode_base_url "https://image-charts.com/chart?chs=150x150&cht=qr&chl="

  def fetch_qrcode(texto) do
    url = "#{@qrcode_base_url}#{URI.encode(texto)}"
      {:ok, url}
  end
      
end
