defmodule Day15.A do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1, reverse: 1]
  import List, only: [flatten: 1, flatten: 2, replace_at: 3]
  import IO

  @target 2_000_000

  def call do
    input = File.read!("lib/day15/input") |> trim()

    res =
      input
      |> split("\n")
      |> map(fn line ->
        [x, y, x2, y2] = split(line, ",")
        x = to_integer(x)
        y = to_integer(y)
        x2 = to_integer(x2)
        y2 = to_integer(y2)
        radius = abs(x - x2) + abs(y - y2)

        generated_covered_coordinates(x, y, radius)
        |> List.delete({x2, y2})
      end)
      |> flatten()
      |> uniq()
      |> count()

    puts(res)
  end

  def generated_covered_coordinates(x, y, radius) do
    for i <- (x - radius)..(x + radius) do
      leftover = radius - abs(x - i)

      if y - leftover <= @target && @target <= y + leftover do
        {i, @target}
      end
    end
    |> reject(&is_nil/1)
  end
end
