defmodule DFS do
  # ---------------------------------------------------------------
  # Entry point
  # ---------------------------------------------------------------
  def run(file) do
    grid =
      file
      |> File.stream!()
      |> Enum.map(&String.trim_trailing/1)
      |> Enum.map(&String.graphemes/1)

    start = find_start(grid)

    memo = %{}
    {paths, _memo} = dfs(grid, start, memo)

    IO.puts(paths)
    :ok
  end

  # ---------------------------------------------------------------
  # DFS WITH MEMOIZATION
  # ---------------------------------------------------------------

  # Memo-hit clause: if we've already computed this pos, reuse it
  defp dfs(_grid, pos, memo) when is_map_key(memo, pos) do
    {memo[pos], memo}
  end

  # Base case: reached bottom row -> one valid path
  defp dfs(grid, {row, col} = pos, memo) when row == length(grid) - 1 do
    {1, Map.put(memo, pos, 1)}
  end

  # General DFS step: dispatch by tile
  defp dfs(grid, {row, col} = pos, memo) do
    tile = grid |> Enum.at(row) |> Enum.at(col)
    {result, memo} = dfs_clause(tile, grid, pos, memo)
    {result, Map.put(memo, pos, result)}
  end

  # ---------------------------------------------------------------
  # TILE CLAUSES — no nested case statements
  # ---------------------------------------------------------------

  # Straight downward movement 
  defp dfs_clause(tile, grid, {row, col}, memo) when tile in [".", "S"] do
    dfs(grid, {row + 1, col}, memo)
  end

  # Splitter: branch left and right
  defp dfs_clause("^", grid, {row, col}, memo) do
    {left_count, memo}  = dfs_safe(grid, {row + 1, col - 1}, memo)
    {right_count, memo} = dfs_safe(grid, {row + 1, col + 1}, memo)
    {left_count + right_count, memo}
  end

  # Anything else: dead path
  defp dfs_clause(_other, _grid, _pos, memo) do
    {0, memo}
  end

  # ---------------------------------------------------------------
  # SAFE DFS — returns 0 for out-of-bounds branches
  # ---------------------------------------------------------------
  defp dfs_safe(grid, {row, col} = pos, memo) do
    if in_bounds?(grid, row, col) do
      dfs(grid, pos, memo)
    else
      {0, memo}
    end
  end

  # ---------------------------------------------------------------
  # Utilities
  # ---------------------------------------------------------------
  defp find_start(grid) do
    row = Enum.find_index(grid, &Enum.member?(&1, "S"))
    col = Enum.find_index(Enum.at(grid, row), &(&1 == "S"))
    {row, col}
  end

  defp in_bounds?(grid, row, col) do
    row >= 0 and row < length(grid) and
      col >= 0 and col < length(Enum.at(grid, row))
  end
end
