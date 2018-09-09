defmodule Helper.Application do
  use Application

  def start(_type, _args) do
    children = [
      Helper.Store
    ]

    opts = [strategy: :one_for_one, name: Helper.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
