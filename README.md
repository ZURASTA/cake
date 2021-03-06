# Cake (Email Delivery)

[![Stories in Ready](https://badge.waffle.io/ZURASTA/cake.png?label=ready&title=Ready)](https://waffle.io/ZURASTA/cake?utm_source=badge)
[![CircleCI](https://circleci.com/gh/ZURASTA/cake.svg?style=svg)](https://circleci.com/gh/ZURASTA/cake)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/ZURASTA/cake.svg)](https://beta.hexfaktor.org/github/ZURASTA/cake)

Provides support for composing emails from reusable templates and utilises the `Swoosh` library to provide support for delivering emails.


### Usage

The service component (`Cake.Service`) is an OTP application that should be started prior to making any requests to the service. This component should only be interacted with to configure/control the service explicitly.

An API (`Cake.API`) is provided to allow for convenient interaction with the service from external applications.

An email composition library (`Cake.Email`) is provided to simplify the creation of emails.


### Composing Emails

Emails can be created from a template or a pre-existing email representation. Email templates are reusable maps that can be used to generate an email representation.

```elixir
defmodule InvoiceTemplate do
    defstruct [
        formatter: &InvoiceTemplate.format/1,
        client: nil,
        amount: nil,
        date: nil
    ]

    def format(%{ client: { name, email }, amount: amount, date: date }) do
        %Cake.Email{
            from: "billings@foo.bar",
            to: email,
            subject: "Invoice for #{date}",
            body: %Cake.Email.Body{
                text: "Hi #{name}, your account was billed #{amount} for the period (#{date})."
            }
        }
    end
end

Cake.API.Mailer.post(%InvoiceTemplate{ client: { "Foo", "foo@bar" }, amount: "$100", date: "January" })
```

To see more on how composing works see `Cake.Email.compose/2`.


Configuration
-------------

The service may be configured with the following options:

### Server

The service can be made available through various methods customisable using the `:server` key in the service and API configs. The `:server:` key expects the value to be a function that accepts a module and returns a value acceptable by the `server` argument of GenServer requests, or name field of GenServer registration. Some examples of this can be:

#### Local Named Server

```elixir
config :cake_service,
    server: &(&1)

config :cake_api,
    server: &(&1)
```

#### Distributed Named Server

```elixir
config :cake_service,
    server: &(&1)

config :cake_api,
    server: &({ &1, :"foo@127.0.0.1" })
```

#### Swarm Registered Server

```elixir
config :cake_service,
    server: &({ :via, :swarm, &1 })

config :cake_api,
    server: &({ :via, :swarm, &1 })
```

### Email Server

The email service can be configured by providing the config for the key `Cake.Service.Mailer.Dispatch`.

For details on how to configure a [Swoosh mailer](https://hexdocs.pm/swoosh/Swoosh.Mailer.html).
