defmodule Day10.A do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1]
  import IO

  def call do
    input = File.read!("lib/day10/input") |> trim()

    res =
      input
      |> split("\n")
      |> map(fn
        "noop" ->
          0

        "addx " <> n ->
          n = to_integer(n)

          [0, n]
      end)
      |> List.flatten()
      |> reduce([1], fn n, acc ->
        [current_value | _] = acc

        [current_value + n | acc]
      end)
      |> Enum.reverse()
      |> then(fn res ->
        20 * at(res, 19) +
          60 * at(res, 59) +
          100 * at(res, 99) +
          140 * at(res, 139) +
          180 * at(res, 179) +
          220 * at(res, 219)
      end)

    puts(res)
  end
end
