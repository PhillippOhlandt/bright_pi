defmodule BrightPi.Board do
  @moduledoc false

  use GenServer
  use BrightPi.Constants

  alias BrightPi.Telemetry
  alias Circuits.I2C
  alias BrightPi.LED

  @led_status_register 0x00
  @led_dim_registers [0x02, 0x04, 0x05, 0x07, 0x01, 0x03, 0x06, 0x08]
  @gain_register 0x09

  def start_link(opts \\ %{}) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(%{address: address, i2c_bus_name: bus_name}) do
    {:ok, i2c_ref} = I2C.open(bus_name)

    state = %{
      address: address,
      i2c_bus_name: bus_name,
      i2c_ref: i2c_ref
    }

    Telemetry.board_init(__MODULE__)

    {:ok, state}
  end

  def init(_opts) do
    {bus_name, address} = I2C.discover_one!([0x70])

    init(%{address: address, i2c_bus_name: bus_name})
  end

  def handle_call({:set_leds, leds}, _from, state) when is_list(leds) do
    with leds_bitstring <- LED.leds_to_bitstring(leds),
         {:ok, leds_on} <-
           I2C.write_read(state.i2c_ref, state.address, [@led_status_register, leds_bitstring], 1),
         leds_on_list <- LED.bitstring_to_leds(leds_on) do
      Telemetry.set_leds(leds, __MODULE__)

      {:reply, {:ok, leds_on_list}, state}
    else
      error -> {:reply, error, state}
    end
  end

  def handle_call(:get_leds, _from, state) do
    with {:ok, leds_on} <-
           I2C.write_read(state.i2c_ref, state.address, <<@led_status_register>>, 1),
         leds_on_list <- LED.bitstring_to_leds(leds_on) do
      {:reply, {:ok, leds_on_list}, state}
    else
      error -> {:reply, error, state}
    end
  end

  def handle_call({:set_leds_dim, leds, dim}, from, state)
      when is_list(leds) and dim in @min_dim..@max_dim do
    registers = leds |> Enum.map(&Enum.at(@led_dim_registers, &1 - 1))

    for register <- registers do
      {:ok, <<^dim>>} = Circuits.I2C.write_read(state.i2c_ref, state.address, [register, dim], 1)
    end

    Telemetry.set_leds_dim(leds, dim, __MODULE__)

    handle_call(:get_leds_dim, from, state)
  end

  def handle_call(:get_leds_dim, _from, state) do
    result =
      @led_dim_registers
      |> Enum.map(fn register ->
        {:ok, <<dim>>} = I2C.write_read(state.i2c_ref, state.address, <<register>>, 1)
        dim
      end)

    {:reply, {:ok, result}, state}
  end

  def handle_call({:set_gain, gain}, _from, state) when gain in @min_gain..@max_gain do
    with {:ok, <<gain>>} <-
           I2C.write_read(state.i2c_ref, state.address, [@gain_register, gain], 1) do
      Telemetry.set_gain(gain, __MODULE__)

      {:reply, {:ok, gain}, state}
    else
      error -> {:reply, error, state}
    end
  end

  def handle_call(:get_gain, _from, state) do
    with {:ok, <<gain>>} <- I2C.write_read(state.i2c_ref, state.address, <<@gain_register>>, 1) do
      {:reply, {:ok, gain}, state}
    else
      error -> {:reply, error, state}
    end
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end
