defmodule MathHomework2 do
  def run(file) do
    rows = 
      file
      |> File.stream!()
      |> Stream.map(&String.trim_trailing(&1, "\n"))
      |> Enum.to_list()
    
    {digits, [operations]} = Enum.split(rows, length(rows) - 1)

    equations = build_equations(digits, operations)
    result = evaluate(equations)

    IO.inspect(result, label: "Final Result")
  end

  defp str_to_num_list([], curr, acc), do: [curr | acc] 
  defp str_to_num_list([h | t], curr, acc) when h == "" do 
    str_to_num_list(t, [], [curr | acc])
  end
  defp str_to_num_list([h | t], curr, acc) do
    str_to_num_list(t, [String.to_integer(h) | curr], acc)
  end

  defp build_equations(digits, operations) do
    digits =
      digits
      |> Enum.map(&String.graphemes/1)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&List.to_string/1)
      |> Enum.map(&String.trim/1)      
      |> str_to_num_list([],[])
    
    equations = 
      operations
      |> String.split()
      |> Enum.reverse()
      |> Enum.map(&String.to_atom/1)
      |> Enum.zip(digits)

    equations
  end

  defp evaluate(equations) do
    equations
    |> Enum.map(fn
      { :+, values } -> Enum.sum(values)
      { :*, values } -> Enum.product(values)
    end)

    |> Enum.sum()
  end
end
