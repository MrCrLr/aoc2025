defmodule FindJoltage do
  def run(file) do
    file
    |> File.stream!()
    |> Enum.map(&String.trim/1) 
    |> process(0)
  end
  
  defp process([], joltage), do: joltage

  defp process([head | rest], joltage) do
    bank = String.graphemes(head) 
    battery = build_battery(bank, "", 12)
    process(rest, joltage + battery)
  end
  
  defp build_battery(_bank, battery, 0), do: String.to_integer(battery)

  defp build_battery(bank, battery, rem) 
       when length(bank) == rem do
    build_battery(bank, battery <> Enum.join(bank), 0) 
  end

  defp build_battery(bank, battery, rem) do
    len = length(bank)
    cell = 
      bank 
      |> Enum.slice(0..len - rem) 
      |> Enum.max()

    index = Enum.find_index(bank, fn x -> x == cell end)
    new_bank = Enum.slice(bank, index + 1, len) 

    build_battery(new_bank, battery <> cell, rem - 1)
  end
end
