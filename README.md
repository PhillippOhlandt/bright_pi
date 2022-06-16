# BrightPi

![Test Status](https://github.com/PhillippOhlandt/bright_pi/actions/workflows/tests.yml/badge.svg)
![Latest Version](https://img.shields.io/hexpm/v/bright_pi.svg)

BrightPi is a library to talk to the [Pi Supply Bright Pi](https://uk.pi-supply.com/products/bright-pi-bright-white-ir-camera-light-raspberry-pi) board
featuring 4 white LEDs and 4 pairs of two infrared LEDs.

This library can control the on/off value of each LED or LED pair,
as well as their dim value and a global gain value.

## Examples

```elixir
# Turn all white LEDs on
iex> BrightPi.set_leds([1, 2, 3, 4])
{:ok, [1, 2, 3, 4]}

# Turn all infrared LEDs on
iex> BrightPi.set_leds([5, 6, 7, 8])
{:ok, [5, 6, 7, 8]}

# Dim some LEDs
iex> BrightPi.set_leds_dim([1, 2, 3, 4], 10)
{:ok, [10, 10, 10, 10, 1, 1, 1, 1]}

# Set gain for all LEDs
iex> BrightPi.set_gain(10)
{:ok, 10}
```

## Installation

The package can be installed
by adding `bright_pi` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bright_pi, "~> 1.0"}
  ]
end
```

## Setup

In order to use the library, the board process needs to be added to the supervision tree.

```elixir
defmodule MyApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BrightPi.board()
    ]
    
    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

By default, the `BrightPi.board/0` helper function returns the `BrightPi.Board`
module which talks to the real LED board over I2C.

For local development, the `BrightPi.VirtualBoard` module can be configured via application configuration:

```elixir
# config/host.exs

config :bright_pi, board: BrightPi.VirtualBoard
```

The `BrightPi.VirtualBoard` module mocks all the functionality of the real LED board.

Depending on the application setup,
each board can also be started explicitly in the supervision tree,
as long as the proper board is set via configuration in each environment.

The whole documentation can be found at [https://hexdocs.pm/bright_pi](https://hexdocs.pm/bright_pi).
