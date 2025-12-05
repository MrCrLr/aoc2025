defmodule PaperRoll do
  def run(file) do
    file
    |> File.stream!()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn { line, y }, grid ->
      chars = 
        line
        |> String.trim()
        |> String.graphemes()
        |> Enum.with_index()

      Enum.reduce(chars, grid, fn { char, x }, acc ->
        Map.put(acc, { x, y }, char)
      end)
    end)
    |> total_removed()
    |> elem(1)
  end

  defp total_removed(grid), do: _total_removed(grid, 0)
  defp _total_removed(grid, total) do
    case count_accessible(grid) do
      { new_grid, 0 } -> 
        { new_grid, total }

      { new_grid, removed } ->
        _total_removed(new_grid, total + removed)
    end
  end

  defp count_accessible(grid) do
    { final_grid, count } =
      Enum.reduce(grid, { grid, 0 }, fn { coord, char }, { g, acc } ->
        check_item(char, g, coord, acc)
      end)

    { final_grid, count }
  end

  defp check_item("@", grid, coord, acc),
    do: process_roll(grid, coord, acc)

  defp check_item(_, grid, _coord, acc),
    do: { grid, acc }

  defp process_roll(grid, coord, acc) do
    roll_count =
      coord
      |> neighbors()
      |> Enum.count(fn c -> Map.get(grid, c) == "@" end)

    apply_roll_rule(grid, coord, roll_count, acc)
  end

  defp apply_roll_rule(grid, coord, roll_count, acc) 
       when roll_count < 4 do 
    new_grid = Map.put(grid, coord, ".")
    { new_grid, acc + 1 }
  end

  defp apply_roll_rule(grid, _coord, _roll_count, acc),
    do: { grid, acc }

  defp neighbors({ x, y }) do
    [
      { x,     y - 1 },
      { x + 1, y - 1 },
      { x + 1, y     },
      { x + 1, y + 1 },
      { x,     y + 1 },
      { x - 1, y + 1 },
      { x - 1, y     },
      { x - 1, y - 1 }
    ]
  end
end
