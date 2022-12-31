defmodule Day25.A do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1, reverse: 1]
  import List, only: [flatten: 1, flatten: 2, replace_at: 3]
  import IO

  @decoder %{
    ?2 => 2,
    ?1 => 1,
    ?0 => 0,
    ?- => -1,
    ?= => -2
  }

  @encoder Map.new(@decoder, fn {key, val} -> {val, key} end)

  def call do
    input = File.read!("lib/day25/input") |> trim()

    res =
      input
      |> split("\n")
      |> map(&String.to_charlist/1)
      |> map(&Enum.reverse/1)
      |> map(fn line -> line |> with_index() |> reduce(0, fn {char, i}, acc -> acc + @decoder[char] * 5 ** i end) end)
      |> sum()
      |> encode([])

    puts(res)
  end

  def encode(0, acc), do: acc

  def encode(number, acc) do
    remm = rem(number, 5)

    cond do
      remm in [0, 1, 2] ->
        encode(div(number, 5), [@encoder[remm] | acc])

      true ->
        encode(div(number, 5) + 1, [@encoder[remm - 5] | acc])
    end
  end
end
