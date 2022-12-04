defmodule Day4.B do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1]
  import IO

  def call do
    input = File.read!("lib/day4/input") |> trim()

    res =
      input
      |> split("\n")
      |> count(fn line ->
        [[_, a, b, c, d]] = Regex.scan(~r/(\d+)-(\d+),(\d+)-(\d+)/, line)
        a = String.to_integer(a)
        b = String.to_integer(b)
        c = String.to_integer(c)
        d = String.to_integer(d)

        !((a < c && b < c) || (a > d && b > d))
      end)

    puts(res)
  end
end
