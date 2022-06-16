defmodule BrightPi.Telemetry do
  @moduledoc """
  Telemetry events for actions on the LED board.

  ### Board Events

  BrightPi emits the following telemetry event during the `init/1` call of a board:

  * `[:bright_pi, :board, :init]`

  The event contains the following measurements:

  * `:system_time` - The system's time when board was initialized

  The event contains the following metadata:

  * `:board` - The board module

  ### LED Events

  BrightPi emits the following telemetry events for LED changes:

  * `[:bright_pi, :leds, :set]` - when a list of LEDs are turned on
  * `[:bright_pi, :leds, :dim]` - when a list of LEDs are dimmed
  * `[:bright_pi, :leds, :gain]` - when the gain for all LEDs is changed

  The events contain the following data:

  | event   | measurements                      | metadata |
  | ------- | --------------------------------- | -------- |
  | `:set`  | `:system_time`, `:leds`           | `:board` |
  | `:dim`  | `:system_time`, `:leds`, `:value` | `:board` |
  | `:gain` | `:system_time`, `:value`          | `:board` |

  #### Measurements

  * `:system_time` - The system's time during the event
  * `:leds` - The list of effected LEDs
  * `:value` - The specific value for `:dim` or `:gain`

  #### Metadata

  * `:board` - The board module
  """

  @doc false
  def board_init(board) do
    time = System.system_time()

    :telemetry.execute(
      [:bright_pi, :board, :init],
      %{
        system_time: time
      },
      %{board: board}
    )
  end

  @doc false
  def set_leds(leds, board) do
    time = System.system_time()

    :telemetry.execute(
      [:bright_pi, :leds, :set],
      %{
        system_time: time,
        leds: leds
      },
      %{board: board}
    )
  end

  @doc false
  def set_leds_dim(leds, dim, board) do
    time = System.system_time()

    :telemetry.execute(
      [:bright_pi, :leds, :dim],
      %{
        system_time: time,
        leds: leds,
        value: dim
      },
      %{board: board}
    )
  end

  @doc false
  def set_gain(gain, board) do
    time = System.system_time()

    :telemetry.execute(
      [:bright_pi, :leds, :gain],
      %{
        system_time: time,
        value: gain
      },
      %{board: board}
    )
  end
end
