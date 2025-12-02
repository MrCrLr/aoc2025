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
          str = Integer.to_string(num)
          len = String.length(str)
          acc + splitter(str, len, num)
      end
    process(t, new_acc)
  end  
   
  defp splitter(str, len, num) when rem(len, 2) == 0 do
    {left, right} = String.split_at(str, div(len, 2))
    halves_equal?(left, right, num)
  end
  defp splitter(_str, _len, _num), do: 0
  defp halves_equal?(left, right, num) when left == right, do: num 
  defp halves_equal?(_left, _right, _num), do: 0

end
