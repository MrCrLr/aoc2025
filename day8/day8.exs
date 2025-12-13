defmodule XYZ do
  @k 1000

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
    # IO.inspect(graph)
    distance_pairs = 
      get_distances(graph, {0, 0}, len, [])

    sorted_edges = 
      clean_and_sort(distance_pairs)

    circuits = 
      build_circuits(graph, sorted_edges, @k)

    circuits
    |> Map.values()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp build_circuits(graph, sorted_edges, limit) do
    {parents, sizes} = init_sets(graph)
    # IO.inspect(parents)
    # IO.inspect(sizes)
    {_, final_sizes} = 
      sorted_edges
      |> Enum.take(limit)
      |> Enum.reduce({parents, sizes}, fn {{i, j}, _dist}, state ->
        a = Enum.at(graph, i)
        b = Enum.at(graph, j)
        union(state, a, b)
      end)

    final_sizes
  end

  # ---------- Union-Find (Disjoint Set Union) ---------- #

  defp init_sets(graph) do
    parents = Map.new(graph, fn p -> {p, p} end)
    sizes   = Map.new(graph, fn p -> {p, 1} end)
    {parents, sizes}
  end

  defp find(parents, x) do
    case Map.fetch!(parents, x) do
      ^x ->
        {x, parents}
      parent ->
        {root, parents} = find(parents, parent)
        {root, Map.put(parents, x, root)}
    end
  end

  defp union({parents, sizes}, a, b) do
    {ra, parents} = find(parents, a)
    {rb, parents} = find(parents, b)

    union_roots({parents, sizes}, ra, rb)
  end

  defp union_roots(state, root, root), do: state
  
  defp union_roots({parents, sizes}, ra, rb) do
    sa = Map.fetch!(sizes, ra)
    sb = Map.fetch!(sizes, rb)

    attach({parents, sizes}, ra, sa, rb, sb)
  end

  defp attach({parents, sizes}, ra, sa, rb, sb) when sa >= sb do
    parents = Map.put(parents, rb, ra)

    sizes =
      sizes
      |> Map.put(ra, sa + sb)
      |> Map.delete(rb)
    {parents, sizes}
  end

  defp attach(state, ra, sa, rb, sb) do
        attach(state, rb, sb, ra, sa)
  end

  # ---------- Parse data and get distances ----------#

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
