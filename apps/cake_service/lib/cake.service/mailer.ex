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
        GenServer.start_link(__MODULE__, [], name: Application.get_env(:cake_service, :server, &(&1)).(__MODULE__))
    end

    def handle_call({ :post, { email } }, from, state) do
        Task.start(fn -> GenServer.reply(from, Dispatch.post(email)) end)
        { :noreply, state }
    end
    def handle_call({ :post, { email, attributes } }, from, state) do
        Task.start(fn -> GenServer.reply(from, Dispatch.post(email, attributes)) end)
        { :noreply, state }
    end
    def handle_call({ :swarm, :begin_handoff }, _from, state), do: { :reply, :restart, state }

    def handle_cast({ :swarm, :end_handoff }, state), do: { :noreply, state }
    def handle_cast({ :swarm, :resolve_conflict, _state }, state), do: { :noreply, state }

    def handle_info({ :swarm, :die }, state), do: { :stop, :shutdown, state }
end
