defmodule Day3.B do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1]
  import IO

  def call do
    input = File.read!("lib/day3/input") |> trim()

    res =
      input
      |> split("\n")
      |> find_common_char_in_groups()
      |> map(&get_priority/1)
      |> sum()

    puts(res)
  end

  def find_common_char_in_groups(lines) do
    groups_count = div(length(lines), 3)

    for group_index <- 0..(groups_count - 1) do
      line1 = at(lines, group_index * 3)
      line2 = at(lines, group_index * 3 + 1)
      line3 = at(lines, group_index * 3 + 2)

      find_common_char(line1, line2, line3)
    end
  end

  def find_common_char(line1, line2, line3) do
    part1 = MapSet.new(String.to_charlist(line1))
    part2 = MapSet.new(String.to_charlist(line2))
    part3 = MapSet.new(String.to_charlist(line3))

    part1
    |> MapSet.intersection(part2)
    |> MapSet.intersection(part3)
    |> MapSet.to_list()
    |> at(0)
  end

  def get_priority(code) when code in ?a..?z, do: code - ?a + 1
  def get_priority(code) when code in ?A..?Z, do: code - ?A + 27
end
