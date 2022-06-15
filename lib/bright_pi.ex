defmodule BrightPi do
  @moduledoc """
  Documentation for `BrightPi`.
  """

  use BrightPi.Constants

  def set_leds(leds) when is_list(leds) do
    GenServer.call(board(), {:set_leds, leds})
  end

  def get_leds() do
    GenServer.call(board(), :get_leds)
  end

  def set_leds_dim(leds, dim) when is_list(leds) and dim in @min_dim..@max_dim do
    GenServer.call(board(), {:set_leds_dim, leds, dim})
  end

  def get_leds_dim() do
    GenServer.call(board(), :get_leds_dim)
  end

  def set_gain(gain) when gain in @min_gain..@max_gain do
    GenServer.call(board(), {:set_gain, gain})
  end

  def get_gain() do
    GenServer.call(board(), :get_gain)
  end

  def board() do
    Application.get_env(:bright_pi, :board, BrightPi.Board)
  end
end
