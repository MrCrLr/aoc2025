defmodule FreshItems do
  def run(file) do
    lines =
      File.stream!(file)
      |> Enum.map(&String.trim/1)

  end
end

