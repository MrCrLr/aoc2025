defmodule Grid do
  def load(filepath) do
    filepath
    |> File.stream!()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, grid ->
      chars = 
        line
        |> String.trim()
        |> String.graphemes()
        |> Enum.with_index()

      Enum.reduce(chars, grid, fn {char, x}, acc ->
        Map.put(acc, {x, y}, char)
      end)
    end)
    # |> IO.inspect(label: "Grid Map")
  end
end
