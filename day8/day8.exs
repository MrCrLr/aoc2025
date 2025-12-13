defmodule XYZ do
  def run(file) do
    graph =
      File.stream!(file)
      |> Enum.map(&String.trim_trailing/1)
      |> Enum.map(fn line ->
        line
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(&List.to_tuple/1)
    
    len = length(graph)

    distance_pairs = 
      get_distances(graph, {0, 0}, len, [])

    sorted_distances = 
      clean_and_sort(distance_pairs)

    IO.inspect(sorted_distances)
  end

  defp clean_and_sort(distance_pairs) do 
    distance_pairs
    |> Enum.uniq_by(fn {_coords, dist} -> dist end)
    |> Enum.sort_by( fn {_coords, dist} -> dist end, :asc)
  end

  defp get_distances(_graph, {i, _j}, len, acc) when i == len, do: acc

  defp get_distances(graph, {i, j}, len, acc) when j >= len do
    get_distances(graph, {i + 1, 0}, len, acc)
  end

  defp get_distances(graph, {i, j}, len, acc) when i == j do
    get_distances(graph, {i, j + 1}, len, acc)
  end

  defp get_distances(graph, {i, j} = coords, len, acc) do
    a = Enum.at(graph, i)
    b = Enum.at(graph, j) 

    entry_value = Geometry.distance(a, b)

    get_distances(
      graph, 
      {i, j + 1}, 
      len, 
      [{coords, entry_value} | acc]
    )
  end 
end

defmodule Geometry do
  def distance({x, y, z}, {a, b, c}) do
    :math.sqrt(
      :math.pow(a - x, 2) +
      :math.pow(b - y, 2) +
      :math.pow(c - z, 2)
    )
  end
end
