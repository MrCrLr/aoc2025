defmodule MathHomework2 do
  def run(file) do
    rows = 
      file
      |> File.stream!()
      |> Stream.map(&String.trim_trailing(&1, "\n"))
      |> Enum.to_list()
    
    {digits, [operations]} = Enum.split(rows, length(rows) - 1)
    digits =
      digits
      |> Enum.map(&String.graphemes/1)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&List.to_string/1)
      |> Enum.map(&String.trim/1)      
      |> str_to_num_list([],[])

    # pivot = build_pivot_map(digits, operations)

    IO.inspect(digits, label: "Digits")
    IO.inspect(operations, label: "Operations")
    # IO.inspect(pivot, label: "Pivot")

    # result = evaluate(pivot)
    # IO.inspect(result, label: "Final Result")
  end

  defp str_to_num_list([], curr, acc), do: [curr | acc] 
  defp str_to_num_list([h | t], curr, acc) when h == "" do 
    str_to_num_list(t, [], [curr | acc])
  end
  defp str_to_num_list([h | t], curr, acc) do
    str_to_num_list(t, [String.to_integer(h) | curr], acc)
  end

  defp evaluate(pivot) do
    pivot
    |> Enum.map(fn
      {:+, values} ->
        values
        |> Enum.map(&String.to_integer/1)
        |> Enum.sum()

      {:*, values} ->
        values
        |> Enum.map(&String.to_integer/1)
        |> Enum.product()
    end)
    |> Enum.sum()
  end

  defp build_pivot_map(digits, operations) do
    columns = 
      digits 
      |> Enum.zip() 
      |> Enum.map(&Tuple.to_list/1)
    
    operations
    |> Enum.map(&String.to_atom/1)
    |> Enum.zip(columns)
  end
end
