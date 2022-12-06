defmodule Day6.B do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1]
  import IO

  def call do
    input = File.read!("lib/day6/input") |> trim() |> String.to_charlist()

    res = traverse(input, 0)

    puts(res)
  end

  def traverse(input, index) do
    part = slice(input, index, 14)

    if part == uniq(part) do
      index + 14
    else
      traverse(input, index + 1)
    end
  end
end
