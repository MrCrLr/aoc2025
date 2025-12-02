defmodule FindPassword do
  def run(file) do
    file
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&convert/1)
    |> process(50, 0)
  end

  defp process([], _pos, count), do: count

  defp process([h | t], pos, count) do
    {new_pos, passed} = rotate(pos, h, 0)
    process(t, new_pos, count + passed)
  end

  defp rotate(pos, 0, count), do: {pos, count}

  defp rotate(pos, h, count) when h > 0 do
    new_pos = rem(pos + 1, 100)
    rotate(new_pos, h - 1, count + crossed?(new_pos))
  end

  defp rotate(pos, h, count) when h < 0 do
    new_pos = rem(pos - 1 + 100, 100)
    rotate(new_pos, h + 1, count + crossed?(new_pos))
  end

  defp crossed?(0), do: 1
  defp crossed?(_new_pos), do: 0

  defp convert(<<"L", num::binary>>), do: -String.to_integer(num)
  defp convert(<<"R", num::binary>>), do: String.to_integer(num)
end

