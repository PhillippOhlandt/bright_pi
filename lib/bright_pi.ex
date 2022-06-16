defmodule BrightPi do
  @moduledoc """
  BrightPi is a library to talk to the "Pi Supply BrightPi" board
  featuring 4 white LEDs and 4 pairs of two infrared LEDs.

  This library can control the on/off value of each LED or LED pair,
  as well as their dim value and a global gain value.

  LEDs and LED pairs are numbered from 1 to 8.

  The mapping looks like the following (front view, cables at the bottom):

      [4]      [1]
        [7]  [6]

        [8]  [5]
      [3]      [2]

  ## Setup

  In order to use the library, the board process needs to be added to the supervision tree.

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

  By default, the `BrightPi.board/0` helper function returns the `BrightPi.Board`
  module which talks to the real LED board over I2C.

  For local development, the `BrightPi.VirtualBoard` module can be configured via application configuration:

      config :bright_pi, board: BrightPi.VirtualBoard

  The `BrightPi.VirtualBoard` module mocks all the functionality of the real LED board.

  Depending on the application setup,
  each board can also be started explicitly in the supervision tree,
  as long as the proper board is set via configuration in each environment.
  """

  use BrightPi.Constants

  @doc """
  Sets which LEDs should be on.
  LEDs not in the list will be turned off.

  * See `BrightPi` for the LED mapping.

  ## Examples

      BrightPi.set_leds([1, 2, 3, 4]) # same as
      BrightPi.set_leds(BrightPi.LED.all_white())

      BrightPi.set_leds([5, 6, 7, 8]) # same as
      BrightPi.set_leds(BrightPi.LED.all_ir())

      BrightPi.set_leds([1, 2, 3, 4, 5, 6, 7, 8]) # same as
      BrightPi.set_leds(BrightPi.LED.all())

  It returns the list of LEDs that are on:

      iex> BrightPi.set_leds([1, 2, 3, 4])
      {:ok, [1, 2, 3, 4]}
  """
  def set_leds(leds) when is_list(leds) do
    GenServer.call(board(), {:set_leds, leds})
  end

  @doc """
  Gets the list of LEDs that are on.

  * See `BrightPi` for the LED mapping.

  ## Example

      iex> BrightPi.get_leds()
      {:ok, [1, 2, 3, 4]}
  """
  def get_leds() do
    GenServer.call(board(), :get_leds)
  end

  @doc """
  Sets the dim value for the specified list of LEDs.

  * See `BrightPi` for the LED mapping.
  * See `BrightPi.LED.min_dim/0` for minimum dim value.
  * See `BrightPi.LED.max_dim/0` for maximum dim value.

  ## Example

      iex> BrightPi.set_leds_dim([1, 2, 3, 4], 10)
      {:ok, [10, 10, 10, 10, 1, 1, 1, 1]}
  """
  def set_leds_dim(leds, dim) when is_list(leds) and dim in @min_dim..@max_dim do
    GenServer.call(board(), {:set_leds_dim, leds, dim})
  end

  @doc """
  Gets the list of all LED dim values.

  ## Example

      iex> BrightPi.get_leds_dim()
      {:ok, [1, 1, 1, 1, 1, 1, 1, 1]}
  """
  def get_leds_dim() do
    GenServer.call(board(), :get_leds_dim)
  end

  @doc """
  Sets the gain value of all LEDs.

  * See `BrightPi.LED.min_gain/0` for minimum gain value.
  * See `BrightPi.LED.max_gain/0` for maximum gain value.
  * See `BrightPi.LED.default_gain/0` for default gain value.

  ## Example

      iex> BrightPi.set_gain(10)
      {:ok, 10}
  """
  def set_gain(gain) when gain in @min_gain..@max_gain do
    GenServer.call(board(), {:set_gain, gain})
  end

  @doc """
  Gets the gain value of all LEDs.

  ## Example

      iex> BrightPi.get_gain()
      {:ok, 8}
  """
  def get_gain() do
    GenServer.call(board(), :get_gain)
  end

  @doc """
  Returns the currently configured board module.

  ## Board modules

  * `BrightPi.Board` - Default board
  * `BrightPi.VirtualBoard` - Virtual board for local development
  """
  def board() do
    Application.get_env(:bright_pi, :board, BrightPi.Board)
  end
end
