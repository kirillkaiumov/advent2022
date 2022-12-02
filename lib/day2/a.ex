defmodule Day2.A do
  import Enum, except: [split: 2]
  import String, except: [slice: 2]
  import IO

  @scores %{
    "A" => 1,
    "B" => 2,
    "C" => 3,
    "X" => 1,
    "Y" => 2,
    "Z" => 3
  }

  @priorities %{
    ["A", "X"] => 0,
    ["A", "Y"] => 1,
    ["A", "Z"] => -1,
    ["B", "X"] => -1,
    ["B", "Y"] => 0,
    ["B", "Z"] => 1,
    ["C", "X"] => 1,
    ["C", "Y"] => -1,
    ["C", "Z"] => 0
  }

  def call do
    input = File.read!("lib/day2/input") |> trim()

    res =
      input
      |> split("\n")
      |> map(fn line ->
        [player_1, player_2] = split(line, " ")

        points =
          case @priorities[[player_1, player_2]] do
            -1 -> 0
            0 -> 3
            1 -> 6
          end

        points + @scores[player_2]
      end)
      |> sum()

    puts(res)
  end
end
