defmodule Day2.B do
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

  @player_2_turns %{
    ["A", -1] => "Z",
    ["A", 0] => "X",
    ["A", 1] => "Y",
    ["B", -1] => "X",
    ["B", 0] => "Y",
    ["B", 1] => "Z",
    ["C", -1] => "Y",
    ["C", 0] => "Z",
    ["C", 1] => "X"
  }

  def call do
    input = File.read!("lib/day2/input") |> trim()

    res =
      input
      |> split("\n")
      |> map(fn line ->
        [player_1, player_2] = split(line, " ")

        decision =
          case player_2 do
            "X" -> -1
            "Y" -> 0
            "Z" -> 1
          end

        points =
          case decision do
            -1 -> 0
            0 -> 3
            1 -> 6
          end

        player_2_turn = @player_2_turns[[player_1, decision]]

        points + @scores[player_2_turn]
      end)
      |> sum()

    puts(res)
  end
end
