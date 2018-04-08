defmodule Cake.Service do
    @moduledoc """
      The service application for sending emails.

      ## Configurable Options

      * `:server` - The name the server should be registered as. This takes a
      function that accepts a module and returns a valid named server.

      An example configuration:

        config :cake_service,
            server: &(&1)
    """

    use Application

    @doc """
      Start the service application.
    """
    def start(_type, _args) do
        import Supervisor.Spec, warn: false

        children = [
            Cake.Service.Mailer
        ]

        opts = [strategy: :one_for_one, name: Cake.Service.Supervisor]
        Supervisor.start_link(children, opts)
    end
end
