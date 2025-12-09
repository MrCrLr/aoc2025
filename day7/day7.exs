defmodule Teleporter do
  def repair(file) do
    manifold =
      file
      |> File.stream!()
      |> Enum.map(&String.graphemes/1)

    splits = count_tachyons(manifold, {0, Map.new(), 0})
    IO.puts(splits)    
  end

  defp count_tachyons([], {_i, _beam, acc}), do: acc
  defp count_tachyons([h | t], {i, beam, acc}) do
    { new_beam, new_acc } = scan_row(h, {i, beam, acc})
    count_tachyons(t, {0, new_beam, new_acc})
  end

  defp scan_row([h | t], {i, beam, acc}) when h == "^" do
    case Map.get(beam, i) == true do
      true -> 
        new_beam = 
          beam
          |> Map.put(i - 1, true)
          |> Map.put(i, false)
          |> Map.put(i + 1, true)

        scan_row(t, {i + 1, new_beam, acc + 1})

      false ->
        scan_row(t, {i + 1, beam, acc})
    end
  end

  defp scan_row([h | _t], {i, beam, acc}) when h == "S" do
    new_beam = Map.put(beam, i, true)
    { new_beam, acc }
  end

  defp scan_row([h | _t], {_i, beam, acc}) when h =="\n" do
    { beam, acc }
  end

  defp scan_row([h | t], {i, beam, acc}) when h == "." do
    scan_row(t, {i + 1, beam, acc})
  end
end

