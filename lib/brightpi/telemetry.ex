defmodule BrightPi.Telemetry do
  @moduledoc false

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
