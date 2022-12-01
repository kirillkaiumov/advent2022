defmodule Day1.A do
  def call do
    input = File.read!("lib/day1/input") |> String.trim()

    res =
      input
      |> String.split("\n\n")
      |> Enum.map(fn group -> group |> String.split("\n") |> Enum.map(&String.to_integer/1) end)
      |> Enum.map(&Enum.sum/1)
      |> Enum.max()

    IO.puts(res)
  end
end
