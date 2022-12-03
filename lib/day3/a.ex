defmodule Day3.A do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1]
  import IO

  def call do
    input = File.read!("lib/day3/input") |> trim()

    res =
      input
      |> split("\n")
      |> map(&get_priority/1)
      |> sum()

    puts(res)
  end

  def get_priority(line) do
    line
    |> String.to_charlist()
    |> find_common_char()
    |> then(fn
      code when code in ?a..?z ->
        code - ?a + 1

      code when code in ?A..?Z ->
        code - ?A + 27
    end)
  end

  def find_common_char(line) do
    middle = div(length(line), 2)

    part1 = MapSet.new(slice(line, 0, middle))
    part2 = MapSet.new(slice(line, -middle..-1))

    MapSet.intersection(part1, part2) |> MapSet.to_list() |> at(0)
  end
end
