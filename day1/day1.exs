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
    new_pos = Integer.mod(h + pos, 100)
    case new_pos do
      0 -> hit_zero(t, new_pos, count + 1)
      _ -> hit_zero(t, new_pos, count)
    end 
  end

  defp convert(<<"L", num::binary>>), do: String.to_integer(num) * -1
  defp convert(<<"R", num::binary>>), do: String.to_integer(num)
end
