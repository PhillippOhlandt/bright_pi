defmodule BrightPi.FakeBoard do
  @moduledoc false

  use GenServer
  use BrightPi.Constants

  alias BrightPi.LED
  alias BrightPi.Telemetry

  def start_link(opts \\ %{}) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    state = %{
      leds_on: [],
      leds_dim: [1, 1, 1, 1, 1, 1, 1, 1],
      gain: 1
    }

    Telemetry.board_init(__MODULE__)

    {:ok, state}
  end

  def handle_call({:set_leds, leds}, _from, state) when is_list(leds) do
    new_state = %{state | leds_on: leds}

    Telemetry.set_leds(leds, __MODULE__)

    {:reply, {:ok, leds}, new_state}
  end

  def handle_call(:get_leds, _from, state) do
    {:reply, {:ok, state.leds_on}, state}
  end

  def handle_call({:set_leds_dim, leds, dim}, from, state)
      when is_list(leds) and dim in @min_dim..@max_dim do
    new_dim =
      Enum.reduce(leds, state.leds_dim, fn x, acc ->
        List.replace_at(acc, x - 1, dim)
      end)

    new_state = %{state | leds_dim: new_dim}

    Telemetry.set_leds_dim(leds, dim, __MODULE__)

    {:reply, {:ok, new_dim}, new_state}
  end

  def handle_call(:get_leds_dim, _from, state) do
    {:reply, {:ok, state.leds_dim}, state}
  end

  def handle_call({:set_gain, gain}, _from, state) when gain in @min_gain..@max_gain do
    new_state = %{state | gain: gain}

    Telemetry.set_gain(gain, __MODULE__)

    {:reply, {:ok, gain}, new_state}
  end

  def handle_call(:get_gain, _from, state) do
    {:reply, {:ok, state.gain}, state}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end
