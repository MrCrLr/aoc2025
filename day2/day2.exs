defmodule FindInvalid do
  def run(file) do
    file
    |> File.read!()
    |> String.replace("\n", "")
    |> String.split([",","-"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> process(0)
  end

  defp process([], acc), do: acc

  defp process([h1, h2 | t], acc) do
    new_acc = 
      for num <- h1..h2, reduce: acc do
        acc ->
          digits = num |> Integer.to_string() |> String.graphemes() 
          len = Enum.count(digits)
          acc + chunker(digits, len, num)
      end
    process(t, new_acc)
  end 
 
  defp chunker(_digits, len, _num) when len < 2, do: 0   

  defp chunker(digits, len, num) do
    for x <- 1..(div(len, 2) + 1), reduce: 0 do
      0 -> 
        _chunker(digits, len, x, num)
      acc ->
        acc
    end
  end

  defp _chunker(digits, len, x, num) 
       when rem(len, x) == 0 and div(len, x) >= 2 do
    digits 
    |> Enum.chunk_every(x) 
    |> Enum.dedup()
    |> is_repeat?(num)
  end

  defp _chunker(_digit, _len, _x, _num), do: 0

  defp is_repeat?([_only], num), do: num
  defp is_repeat?(_, _num), do: 0
end
