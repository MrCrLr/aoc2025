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

    grouped_distances = 
      create_groups(sorted_distances, 0, 0, [{:g1, []}])

    IO.inspect(grouped_distances)

  end

  defp create_groups(sorted_distances, index, _count, acc) 
       when index == length(sorted_distances), do: acc
  defp create_groups(sorted_distances, 0, 0, acc) do
    {{x, y}, _dist} = Enum.at(sorted_distances, 0)
    create_groups(sorted_distances, 1, 1, Keyword.put(acc, :g1, [x, y]))
  end
  defp create_groups(sorted_distances, index, count, acc) do
    {{x, y}, _dist} = Enum.at(sorted_distances, index)

    keys = Keyword.keys(acc)

    matching_key = 
      Enum.find(keys, fn key ->
        values = Keyword.get(acc, key)
        x in values or y in values
      end)

    new_acc =
      if matching_key do
        Keyword.update!(acc, matching_key, fn values ->
          Enum.uniq(values ++ [x, y])
        end)
      else
        new_key = String.to_atom("g#{count + 1}")
        Keyword.put(acc, new_key, [x, y])
      end 

    new_count =
      if matching_key, do: count, else: count + 1

    create_groups(sorted_distances, index + 1, new_count, new_acc)
  end

  defp clean_and_sort(distance_pairs) do 
    distance_pairs
    |> Enum.uniq_by(fn {_coords, dist} -> dist end)
    |> Enum.sort_by(fn {_coords, dist} -> dist end, :asc)
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
