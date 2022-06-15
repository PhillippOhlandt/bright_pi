defmodule BrightPi.LED do
  @moduledoc false

  use BrightPi.Constants

  def all, do: @leds_all
  def all_white, do: @leds_white
  def all_ir, do: @leds_ir

  def min_dim, do: @min_dim
  def max_dim, do: @max_dim

  def min_gain, do: @min_gain
  def max_gain, do: @max_gain
  def default_gain, do: @default_gain

  def leds_to_bitstring(leds) when is_list(leds) do
    <<
      is_led_on(8, leds)::1,
      is_led_on(4, leds)::1,
      is_led_on(7, leds)::1,
      is_led_on(3, leds)::1,
      is_led_on(2, leds)::1,
      is_led_on(6, leds)::1,
      is_led_on(1, leds)::1,
      is_led_on(5, leds)::1
    >>
  end

  def bitstring_to_leds(bitstring) when is_bitstring(bitstring) do
    mapping = [8, 4, 7, 3, 2, 6, 1, 5]

    for(<<a::1 <- bitstring>>, do: a)
    |> Enum.with_index()
    |> Enum.filter(fn {value, _index} -> value == 1 end)
    |> Enum.map(fn {_value, index} -> Enum.at(mapping, index) end)
    |> Enum.sort()
  end

  defp is_led_on(led, to_turn_on) when is_integer(led) and is_list(to_turn_on) do
    case !!Enum.find(to_turn_on, &(&1 === led)) do
      true -> 1
      false -> 0
    end
  end
end
