defmodule FreshItems do
  def run(file) do
    [ range_lines, int_lines ] =
      File.stream!(file)
      |> Stream.map(&String.trim/1)
      |> Enum.split_while(&(&1 != ""))
    digits = 
      int_lines
      Enum.drop_while(&(&1 == ""))
      Enum.map(&String.to_integer/1)
    ranges = 
      range_lines
      |> Enum.map(fn line ->
        [a, b] = String.split(line, "-")
        String.to_integer(a)..String.to_integer(b)
      end)

    %{ digits: digits, ranges: ranges }
  end
end

