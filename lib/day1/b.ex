defmodule Day1.B do
  def call do
    input = File.read!("lib/day1/input") |> String.trim()

    res =
      input
      |> String.split("\n\n")
      |> Enum.map(fn group ->
        group |> String.split("\n") |> Enum.map(&String.to_integer/1) |> Enum.sum()
      end)
      |> Enum.sort()
      |> Enum.slice(-3..-1)
      |> Enum.sum()

    IO.puts(res)
  end
end
