defmodule Rectangle do
  def find(file) do
    tiles =
      file
      |> File.stream!()
      |> Enum.map(&String.trim_trailing/1)
      |> Enum.map(fn line ->
         line
         |> String.split(",")
         |> Enum.map(&String.to_integer/1)
       end)
      |> Enum.map(&List.to_tuple/1)
      |> Enum.sort(:desc)
    
    area =
      tiles
      |> get_vertices()
      |> get_area()

    IO.puts(area)
  end

  defp get_vertices(tiles) do
    lowest_col = Enum.min_by(tiles, fn {col, _} -> col end) |> elem(0)
    lowest_row = Enum.min_by(tiles, fn {_, row} -> row end) |> elem(1)
 
    v1 = Enum.find(tiles, fn {_a, b} -> b == lowest_row end)    
    v2 = Enum.find(tiles, fn {a, _b} -> a == lowest_col end)    
    
    {v1, v2}
  end

  defp get_area({{a, b}, {x, y}}) do 
   ax = abs(a - x) + 1
   by = abs(b - y) + 1
   ax * by 
  end
end
