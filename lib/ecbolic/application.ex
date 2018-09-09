defmodule Ecbolic.Application do
  use Application

  def start(_type, _args) do
    children = [
      Ecbolic.Store
    ]

    opts = [strategy: :one_for_one, name: Ecbolic.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
