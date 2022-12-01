defmodule Day1.B do
  import Enum, except: [split: 2]
  import String, except: [slice: 2]

  def call do
    input = File.read!("lib/day1/input") |> trim()

    res =
      input
      |> split("\n\n")
      |> map(fn group -> group |> split("\n") |> map(&to_integer/1) |> sum() end)
      |> sort()
      |> slice(-3..-1)
      |> sum()

    IO.puts(res)
  end
end
