defmodule BrightPiTest do
  use ExUnit.Case

  setup_all do
    Application.put_env(:bright_pi, :board, BrightPi.VirtualBoard)
    on_exit(fn -> Application.delete_env(:bright_pi, :board) end)
  end

  setup do
    {:ok, _} = start_supervised(BrightPi.VirtualBoard)
    :ok
  end

  test "board emits an init telemetry event", %{test: test} do
    attach_telemetry_handler(test, [:bright_pi, :board, :init])

    :ok = stop_supervised(BrightPi.VirtualBoard)
    {:ok, _} = start_supervised(BrightPi.VirtualBoard)

    assert_receive {:telemetry_event, [:bright_pi, :board, :init], %{system_time: _},
                    %{
                      board: BrightPi.VirtualBoard
                    }}
  end

  test "board/0" do
    assert BrightPi.board() == BrightPi.VirtualBoard
  end

  test "set_leds/1", %{test: test} do
    attach_telemetry_handler(test, [:bright_pi, :leds, :set])

    assert {:ok, [1, 2, 3, 4]} = BrightPi.set_leds([1, 2, 3, 4])
    assert {:ok, []} = BrightPi.set_leds([])

    assert_receive {:telemetry_event, [:bright_pi, :leds, :set],
                    %{system_time: _, leds: [1, 2, 3, 4]},
                    %{
                      board: BrightPi.VirtualBoard
                    }}

    assert_receive {:telemetry_event, [:bright_pi, :leds, :set], %{system_time: _, leds: []},
                    %{
                      board: BrightPi.VirtualBoard
                    }}
  end

  test "get_leds/0" do
    assert {:ok, []} = BrightPi.get_leds()

    BrightPi.set_leds([1, 2, 3, 4, 5, 6, 7, 8])
    assert {:ok, [1, 2, 3, 4, 5, 6, 7, 8]} = BrightPi.get_leds()
  end

  test "set_leds_dim/2", %{test: test} do
    attach_telemetry_handler(test, [:bright_pi, :leds, :dim])

    assert {:ok, [5, 5, 5, 5, 1, 1, 1, 1]} = BrightPi.set_leds_dim([1, 2, 3, 4], 5)
    assert {:ok, [5, 5, 5, 5, 10, 10, 10, 10]} = BrightPi.set_leds_dim([5, 6, 7, 8], 10)

    assert_receive {:telemetry_event, [:bright_pi, :leds, :dim],
                    %{system_time: _, leds: [1, 2, 3, 4], value: 5},
                    %{
                      board: BrightPi.VirtualBoard
                    }}

    assert_receive {:telemetry_event, [:bright_pi, :leds, :dim],
                    %{system_time: _, leds: [5, 6, 7, 8], value: 10},
                    %{
                      board: BrightPi.VirtualBoard
                    }}
  end

  test "get_leds_dim/0" do
    assert {:ok, [1, 1, 1, 1, 1, 1, 1, 1]} = BrightPi.get_leds_dim()

    BrightPi.set_leds_dim([1, 2, 3, 4], 5)
    assert {:ok, [5, 5, 5, 5, 1, 1, 1, 1]} = BrightPi.get_leds_dim()

    BrightPi.set_leds_dim([5, 6, 7, 8], 10)
    assert {:ok, [5, 5, 5, 5, 10, 10, 10, 10]} = BrightPi.get_leds_dim()
  end

  test "set_gain/1", %{test: test} do
    attach_telemetry_handler(test, [:bright_pi, :leds, :gain])

    assert {:ok, 1} = BrightPi.set_gain(1)
    assert {:ok, 15} = BrightPi.set_gain(15)

    assert_receive {:telemetry_event, [:bright_pi, :leds, :gain], %{system_time: _, value: 1},
                    %{
                      board: BrightPi.VirtualBoard
                    }}

    assert_receive {:telemetry_event, [:bright_pi, :leds, :gain], %{system_time: _, value: 15},
                    %{
                      board: BrightPi.VirtualBoard
                    }}
  end

  test "get_gain/0" do
    assert {:ok, 8} = BrightPi.get_gain()

    BrightPi.set_gain(1)
    assert {:ok, 1} = BrightPi.get_gain()

    BrightPi.set_gain(15)
    assert {:ok, 15} = BrightPi.get_gain()
  end

  defp attach_telemetry_handler(test, event) do
    self = self()

    ExUnit.CaptureLog.capture_log(fn ->
      :telemetry.attach(
        "#{test}",
        event,
        fn name, measurements, metadata, _ ->
          send(self, {:telemetry_event, name, measurements, metadata})
        end,
        nil
      )
    end)
  end
end
