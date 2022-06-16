defmodule BrightPi.VirtualBoard do
  @moduledoc """
  The virtual board implementation for local development.

  The board can be set using application configuration:

      config :bright_pi, board: BrightPi.VirtualBoard

  It can be started explicitly or via the preferred `BrightPi.board/0` helper function.

      defmodule MyApp.Application do
        use Application

        @impl true
        def start(_type, _args) do
          children = [
            BrightPi.VirtualBoard, # explicit
            BrightPi.board() # preferred
          ]

          opts = [strategy: :one_for_one, name: MyApp.Supervisor]
          Supervisor.start_link(children, opts)
        end
      end
  """

  use GenServer
  use BrightPi.Constants

  alias BrightPi.Telemetry

  @doc false
  def start_link(opts \\ %{}) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc false
  @impl true
  def init(_opts) do
    state = %{
      leds_on: [],
      leds_dim: [1, 1, 1, 1, 1, 1, 1, 1],
      gain: 8
    }

    Telemetry.board_init(__MODULE__)

    {:ok, state}
  end

  @impl true
  def handle_call({:set_leds, leds}, _from, state) when is_list(leds) do
    new_state = %{state | leds_on: leds}

    Telemetry.set_leds(leds, __MODULE__)

    {:reply, {:ok, leds}, new_state}
  end

  @impl true
  def handle_call(:get_leds, _from, state) do
    {:reply, {:ok, state.leds_on}, state}
  end

  @impl true
  def handle_call({:set_leds_dim, leds, dim}, _from, state)
      when is_list(leds) and dim in @min_dim..@max_dim do
    new_dim =
      Enum.reduce(leds, state.leds_dim, fn x, acc ->
        List.replace_at(acc, x - 1, dim)
      end)

    new_state = %{state | leds_dim: new_dim}

    Telemetry.set_leds_dim(leds, dim, __MODULE__)

    {:reply, {:ok, new_dim}, new_state}
  end

  @impl true
  def handle_call(:get_leds_dim, _from, state) do
    {:reply, {:ok, state.leds_dim}, state}
  end

  @impl true
  def handle_call({:set_gain, gain}, _from, state) when gain in @min_gain..@max_gain do
    new_state = %{state | gain: gain}

    Telemetry.set_gain(gain, __MODULE__)

    {:reply, {:ok, gain}, new_state}
  end

  @impl true
  def handle_call(:get_gain, _from, state) do
    {:reply, {:ok, state.gain}, state}
  end

  @impl true
  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  @impl true
  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end
