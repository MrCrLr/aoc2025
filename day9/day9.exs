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

    hull = Hull.convex_hull(points)    

    max_area =
      for {x1, y1} <- hull,
          {x2, y2} <- hull,
          x1 != x2 and y1 != y2 do
        (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
      end
      |> Enum.max()

    IO.puts(max_area)
  end

defmodule Hull do
  def convex_hull(points) when length(points) <= 2, do: points

  def convex_hull(points) do
    points
    |> Enum.sort()
    |> build_hull()
  end

  defp build_hull(points) do
    lower = build_half(points, [])
    upper = build_half(Enum.reverse(points), [])
    
    Enum.drop(lower, -1) ++ Enum.drop(upper, -1)
  end

  defp build_half([], acc), do: acc

  defp build_half([p | rest], acc) do
    acc = remove_turns(acc, p)
    build_half(rest, [p | acc])
  end

  defp remove_turns([p2, p1 | rest], p3) do
    if cross(p1, p2, p3) <= 0 do
      remove_turns([p1 | rest], p3)
    else
      [p2, p1 | rest]
    end
  end

  defp remove_turns(acc, _p), do: acc

  defp cross({x1, y1}, {x2, y2}, {x3, y3}) do
    (x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)
  end
end
