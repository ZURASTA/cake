defmodule Cake.Service.Mailer do
    use GenServer

    alias Cake.Service.Mailer.Dispatch

    def child_spec(_args) do
        %{
            id: __MODULE__,
            start: { __MODULE__, :start_link, [] },
            type: :worker
        }
    end

    def start_link() do
        GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def handle_call({ :post, { email } }, _from, state), do: { :reply, Dispatch.post(email), state }
    def handle_call({ :post, { email, attributes } }, _from, state), do: { :reply, Dispatch.post(email, attributes), state }
end
