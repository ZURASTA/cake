defmodule Cake.API.Mailer do
    @moduledoc """
      Handles the dispatching of emails.
    """

    @service Cake.Service.Mailer

    alias Cake.Email

    @doc """
      Send an email.

      #{Cake.API.option_docs}

      Returns `{ :ok, result }` on successful send, where result is the state returned
      by the internal mailing service. Otherwise returns `{ :error, result }`, where
      result is the state returned by the internal mailing service.
    """
    @spec post(Email.t | Email.template, Email.attributes, keyword(any)) :: { :ok, term } | { :error, term }
    def post(email, attributes \\ [], options \\ []) do
        options = Cake.API.defaults(options)
        GenServer.call(options[:server].(@service), { :post, { email, attributes } }, options[:timeout])
    end
end
