defmodule Rectangle do
  def find(file) do
    points =
      file
      |> File.stream!()
      |> Enum.map(&String.trim_trailing/1)
      |> Enum.map(fn line ->
         line
         |> String.split(",")
         |> Enum.map(&String.to_integer/1)
       end)
      |> Enum.map(&List.to_tuple/1)

    get_max_area(points)

  end
  
  defp get_max_area(points) do
    for {a, b} <- points, {x, y} <- points,
        {a, b} < {x, y}, reduce: 0 do 
    best ->
        max(best, area(a, b, x, y))
    end
  end

  defp area(a, b, x, y) do
    (abs(a - x) + 1) * (abs(b - y) + 1)
  end   
end
