defmodule FindPassword do
  def run(file) do
    file
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&convert/1)
    |> hit_zero(50, 0)
  end

  defp hit_zero([], _pos, count), do: count

  defp hit_zero([h | t], pos, count) do 
    full = abs(div(h, 100))
    new_pos = Integer.mod(h + pos, 100)
    crossed = crossed(h, new_pos, pos)
    hit_zero(t, new_pos, count + full + crossed)
  end

  defp crossed(h, new_pos, pos) when h > 0 and new_pos < pos, do: 1
  defp crossed(h, new_pos, pos) when h < 0 and new_pos > pos, do: 1
  defp crossed(_h, _new_pos, _pos), do: 0
  
  defp convert(<<"L", num::binary>>), do: String.to_integer(num) * -1
  defp convert(<<"R", num::binary>>), do: String.to_integer(num)
end
