defmodule BrightPi.Constants do
  @moduledoc false

  @doc false
  defmacro __using__(_opts) do
    quote do
      @leds_white [1, 2, 3, 4]
      @leds_ir [5, 6, 7, 8]
      @leds_all @leds_white ++ @leds_ir

      @min_dim 0
      @max_dim 50

      @min_gain 0
      @max_gain 15
      @default_gain 8
    end
  end
end
