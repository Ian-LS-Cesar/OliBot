defmodule OliBot.Application do

  use Application

  @impl true
  def start(_start_type, _start_args) do
    children = [
      OliBot
    ]
    opts = [strategy: :one_for_one, name: OliBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
