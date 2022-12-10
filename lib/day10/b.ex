defmodule Day10.B do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1, reverse: 1]
  import List, only: [flatten: 1]
  import IO

  def call do
    input = File.read!("lib/day10/input") |> trim()

    input
    |> split("\n")
    |> map(fn
      "noop" -> 0
      "addx " <> n -> [0, to_integer(n)]
    end)
    |> flatten()
    |> reduce([1], fn n, [current_value | _] = acc -> [current_value + n | acc] end)
    |> reverse()
    |> chunk_every(40)
    |> map(fn chunk ->
      reduce(chunk, [], fn sprite_index, acc ->
        crt = if sprite_index - 1 <= length(acc) && length(acc) <= sprite_index + 1, do: "#", else: "."
        [crt | acc]
      end)
    end)
    |> each(fn line -> line |> reverse() |> puts() end)
  end
end
