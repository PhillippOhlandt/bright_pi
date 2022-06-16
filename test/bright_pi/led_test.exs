defmodule BrightPi.LEDTest do
  use ExUnit.Case

  alias BrightPi.LED

  test "exposed constants" do
    assert LED.all() == [1, 2, 3, 4, 5, 6, 7, 8]
    assert LED.all_white() == [1, 2, 3, 4]
    assert LED.all_ir() == [5, 6, 7, 8]
    assert LED.min_dim() == 0
    assert LED.max_dim() == 50
    assert LED.min_gain() == 0
    assert LED.max_gain() == 15
    assert LED.default_gain() == 8
  end

  test "leds_to_bitstring/1" do
    assert LED.leds_to_bitstring([1]) == <<2>>
    assert LED.leds_to_bitstring([1, 2]) == <<10>>
    assert LED.leds_to_bitstring([1, 2, 3, 4]) == <<90>>
    assert LED.leds_to_bitstring([1, 2, 3, 4, 5, 6, 7, 8]) == <<255>>
    assert LED.leds_to_bitstring([]) == <<0>>
  end

  test "bitstring_to_leds/1" do
    assert LED.bitstring_to_leds(<<2>>) == [1]
    assert LED.bitstring_to_leds(<<10>>) == [1, 2]
    assert LED.bitstring_to_leds(<<90>>) == [1, 2, 3, 4]
    assert LED.bitstring_to_leds(<<255>>) == [1, 2, 3, 4, 5, 6, 7, 8]
    assert LED.bitstring_to_leds(<<0>>) == []
  end
end
