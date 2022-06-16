defmodule BrightPi.LED do
  @moduledoc """
  Values for LEDs, dim and gain.
  """

  use BrightPi.Constants

  @doc """
  Returns a list of all LEDs.

  ## Example
      iex> BrightPi.LED.all()
      [1, 2, 3, 4, 5, 6, 7, 8]
  """
  def all, do: @leds_all

  @doc """
  Returns a list of all white LEDs.

  ## Example
      iex> BrightPi.LED.all_white()
      [1, 2, 3, 4]
  """
  def all_white, do: @leds_white

  @doc """
  Returns a list of all infrared LEDs.

  ## Example
      iex> BrightPi.LED.all_ir()
      [5, 6, 7, 8]
  """
  def all_ir, do: @leds_ir

  @doc """
  Returns the minimum dim value.

  ## Example
      iex> BrightPi.LED.min_dim()
      0
  """
  def min_dim, do: @min_dim

  @doc """
  Returns the maximum dim value.

  ## Example
      iex> BrightPi.LED.max_dim()
      50
  """
  def max_dim, do: @max_dim

  @doc """
  Returns the minimum gain value.

  ## Example
      iex> BrightPi.LED.min_gain()
      0
  """
  def min_gain, do: @min_gain

  @doc """
  Returns the maximum gain value.

  ## Example
      iex> BrightPi.LED.max_gain()
      15
  """
  def max_gain, do: @max_gain

  @doc """
  Returns the default gain value.

  ## Example
      iex> BrightPi.LED.default_gain()
      8
  """
  def default_gain, do: @default_gain

  @doc false
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

  @doc false
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
