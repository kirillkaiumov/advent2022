defmodule Day14.A do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1, reverse: 1]
  import List, only: [flatten: 1, replace_at: 3]
  import IO

  def call do
    input = File.read!("lib/day14/input") |> trim()

    rocks =
      input
      |> split("\n")
      |> map(fn line ->
        line
        |> split(" -> ")
        |> map(fn part ->
          [[_, x, y]] = Regex.scan(~r/(\d+),(\d+)/, part)
          {to_integer(x), to_integer(y)}
        end)
      end)
      |> reduce(%{}, fn parts, acc ->
        traverse(parts, acc, 1)
      end)

    res = drop_sands(rocks, 0)

    puts(res)
  end

  def traverse(parts, acc, index) when index == length(parts), do: acc

  def traverse(parts, acc, index) do
    {x1, y1} = at(parts, index - 1)
    {x2, y2} = at(parts, index)

    acc = for(x <- x1..x2, y <- y1..y2, do: {x, y}) |> reduce(acc, fn part, acc -> Map.put(acc, part, 1) end)

    traverse(parts, acc, index + 1)
  end

  def drop_sand(x, y, rocks) when x == -1000 or x == 2000 or y == 2000, do: {:inf, rocks}

  def drop_sand(x, y, rocks) do
    cond do
      rocks[{x, y + 1}] == nil -> drop_sand(x, y + 1, rocks)
      rocks[{x - 1, y + 1}] == nil -> drop_sand(x - 1, y + 1, rocks)
      rocks[{x + 1, y + 1}] == nil -> drop_sand(x + 1, y + 1, rocks)
      true -> {:ok, Map.put(rocks, {x, y}, 1)}
    end
  end

  def drop_sands(rocks, count) do
    case drop_sand(500, 0, rocks) do
      {:ok, rocks} -> drop_sands(rocks, count + 1)
      {:inf, _} -> count
    end
  end
end
