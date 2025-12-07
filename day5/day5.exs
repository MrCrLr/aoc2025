defmodule FreshItems do
  def run(file) do
    { range_lines, int_lines } =
      File.stream!(file)
      |> Stream.map(&String.trim/1)
      |> Enum.split_while(&(&1 != ""))

    digits = 
      int_lines
      |> Enum.drop_while(&(&1 == ""))
      |> Enum.map(&String.to_integer/1)

    ranges = 
      range_lines
      |> Enum.map(fn line ->
        [a, b] = String.split(line, "-")
        String.to_integer(a)..String.to_integer(b)
      end)
    
    count =
      Enum.count(digits, fn d ->
        Enum.any?(ranges, fn r -> d in r end)
      end)

    total =   
      ranges
      |> RangeTools.merge()
      |> RangeTools.total_size()

    IO.puts("Fresh ingredients in list: #{count}")
    IO.puts("Number of ingredients in ranges: #{total}")
  end
end

defmodule RangeTools do
  # Count all integers contained in a list of ranges
  def total_size(ranges) do
    ranges
    |> Enum.map(fn r -> r.last - r.first + 1 end)
    |> Enum.sum()
  end

  def merge(ranges) do
    ranges
    |> Enum.sort_by(& &1.first)
    |> do_merge([])
    |> Enum.reverse()
  end

  # Base case: Nothing left to merge
  defp do_merge([], acc), do: acc

  # First element — accumulator empty
  defp do_merge([r | rest], []), do: do_merge(rest, [r])

  # Ranges overlap or touch -> merge them
  defp do_merge([%Range{first: f1, last: l1} | rest],
                [%Range{first: f2, last: l2} | acc_rest])
       when f1 <= l2 + 1 do
    merged = f2..max(l1, l2)
    do_merge(rest, [merged | acc_rest])
  end

  # Ranges are separate -> push as new
  defp do_merge([r | rest], acc), do: do_merge(rest, [r | acc])
end
