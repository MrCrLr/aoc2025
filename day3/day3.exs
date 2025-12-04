defmodule FindJoltage do
  def run(file) do
    file
    |> File.stream!()
    |> Enum.map(&String.trim/1) 
    |> process(0)
  end
  
  defp process([], joltage), do: joltage

  defp process([bank | rest], joltage) do
    bank = 
      bank 
      |> String.graphemes() 
      |> Enum.map(&String.to_integer/1)
    
    battery1 = 
       bank 
       |> Enum.slice(0..-2//1) 
       |> Enum.max()

    index = Enum.find_index(bank, fn x -> x == battery1 end)

    battery2 = 
      bank 
      |> Enum.slice(index + 1..length(bank)-1) 
      |> Enum.max()

    battery = battery1 * 10 + battery2

    process(rest, joltage + battery)
  end
end
