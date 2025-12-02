defmodule FindPassword do
  def run(file) do
    file
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&convert/1)
    |> pass_zero(50, 0)
  end

  defp pass_zero([], _pos, count), do: count

  defp pass_zero([h | t], pos, count) when h >= 100 do
    pass_zero([h - 100 | t], pos, count + 1)
  end
  
  defp pass_zero([h | t], pos, count) when h <= -100 do
    pass_zero([h + 100 | t], pos, count + 1)
  end

  defp pass_zero([h | t], pos, count) when h + pos >= 100 do
    curr = Integer.mod(h + pos, 100)
    pass_zero(t, curr, count + 1) 
  end

  defp pass_zero([h | t], pos, count) when h + pos < 0 do
    curr = Integer.mod(h + pos, 100)
    pass_zero(t, curr, count + 1) 
  end

  defp pass_zero([h | t], pos, count), do: pass_zero(t, h + pos, count) 
  
  defp convert(<<"L", num::binary>>), do: String.to_integer(num) * -1
  defp convert(<<"R", num::binary>>), do: String.to_integer(num)
end
