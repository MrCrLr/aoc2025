defmodule XYZ do
  @k 1000

  def run(file) do
    points =
      File.stream!(file)
      |> Enum.map(&String.trim_trailing/1)
      |> Enum.map(fn line ->
        line
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(&List.to_tuple/1)
    
    edge_pairs = 
      get_edges(points)

    sorted_edges = 
      clean_and_sort(edge_pairs)

    circuits = 
      build_circuits(points, sorted_edges, @k)

    circuits
    |> Map.values()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp build_circuits(points, sorted_edges, limit) do
    {parents, sizes} = init_sets(points)

    {_, final_sizes} = 
      sorted_edges
      |> Enum.take(limit)
      |> Enum.reduce({parents, sizes}, fn {{a, b}, _}, state ->
        union(state, a, b)
      end)

    final_sizes
  end

  # ---------- Union-Find (Disjoint Set Union) ---------- #

  defp init_sets(points) do
    parents = 
      points
      |> Enum.with_index()
      |> Map.new(fn {_p, i} -> {i, i} end)

    sizes = 
      parents
      |> Map.keys()
      |> Map.new(fn i -> {i, 1} end)

    {parents, sizes}
  end

  defp find(parents, x) do
    case parents[x] do
      ^x -> x
      parent -> find(parents, parent)
    end
  end

  defp union({parents, sizes}, a, b) do
    ra = find(parents, a)
    rb = find(parents, b)

    cond do
      ra == rb ->
        {parents, sizes}

      sizes[ra] >= sizes[rb] ->
        {
          Map.put(parents, rb, ra),
          sizes
          |> Map.put(ra, sizes[ra] + sizes[rb])
          |> Map.delete(rb)
        }

      true ->
        union({parents, sizes}, b, a)
    end
  end

  # ---------- Utilities and Math  ---------- #

  defp clean_and_sort(pairs) do 
    pairs
    |> Enum.uniq_by(fn {_pair, d} -> d end)
    |> Enum.sort_by(fn {_pair, d} -> d end, :asc)
  end

  defp get_edges(points) do
    for {p1, i} <- Enum.with_index(points),
        {p2, j} <- Enum.with_index(points),
        i < j do
      {{i, j}, Geometry.distance(p1, p2)}
    end
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
