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
    |> count_accessible()
  end

  def count_accessible(grid) do
    Enum.reduce(grid, 0, fn { coord, char }, acc ->
      check_item(char, grid, coord, acc)
    end)
  end

  defp check_item("@", grid, coord, acc),
    do: process_roll(grid, coord, acc)

  defp check_item(_, _grid, _coord, acc),
    do: acc

  defp process_roll(grid, coord, acc) do
    roll_count =
      coord
      |> neighbors()
      |> Enum.count(fn c -> Map.get(grid, c) == "@" end)

    apply_roll_rule(roll_count, acc)
  end

  defp apply_roll_rule(roll_count, acc) when roll_count < 4,
    do: acc + 1

  defp apply_roll_rule(_roll_count, acc),
    do: acc

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
