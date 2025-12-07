defmodule MathHomework do
  def run(file) do
    rows = 
      file
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, ~r/\s+/, trim: true))
      |> Enum.to_list()
    
    {digits, [operations]} = Enum.split(rows, length(rows) - 1)

    pivot = build_pivot_map(digits, operations)

    IO.inspect(digits, label: "Digits")
    IO.inspect(operations, label: "Operations")
    IO.inspect(pivot, label: "Pivot")
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
