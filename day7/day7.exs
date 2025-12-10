defmodule Teleporter do
  def repair(file) do
    manifold =
      file
      |> File.stream!()
      |> Enum.map(&String.graphemes/1)

    { beam_data, splits } = count_tachyons(manifold, {0, Map.new(), 0})
    possible_worlds = get_max_worlds(beam_data)

    IO.puts(splits)    
    IO.puts(possible_worlds)
  end

  defp count_tachyons([], {_i, beam, acc}), do: { beam, acc }
  defp count_tachyons([h | t], {i, beam, acc}) do
    { new_beam, new_acc } = scan_row(h, {i, beam, acc})
    count_tachyons(t, {0, new_beam, new_acc})
  end

  defp get_max_worlds(beam) do
    beam
    |> Map.values()              # list of all {state, worlds} tuples
    |> Enum.map(fn {_state, worlds} -> worlds end)
    |> Enum.max(fn -> 0 end)     # default to 0 if empty
  end

  defp scan_row([h | t], {i, beam, acc}) when h == "^" do
    { state, _worlds } = Map.get(beam, i)
    max_worlds = get_max_worlds(beam)
    IO.inspect(beam)
    case state == true do
      true -> 
        new_beam = 
          beam
          |> Map.put(i - 1, {true, max_worlds + 1})
          |> Map.put(i, {false, max_worlds})
          |> Map.put(i + 1, {true, max_worlds + 2})

        scan_row(t, {i + 1, new_beam, acc + 1})

      false ->
        scan_row(t, {i + 1, beam, acc})
    end
  end

  defp scan_row([h | _t], {i, beam, acc}) when h == "S" do
    new_beam = Map.put(beam, i, {true, 0})
    { new_beam, acc }
  end

  defp scan_row([h | _t], {_i, beam, acc}) when h =="\n" do
    { beam, acc }
  end

  defp scan_row([h | t], {i, beam, acc}) when h == "." do
    scan_row(t, {i + 1, beam, acc})
  end
end

