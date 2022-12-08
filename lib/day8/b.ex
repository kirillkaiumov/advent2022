defmodule Day8.B do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1]
  import IO

  defmodule Directory do
    defstruct [:id, :name, :file_ids, :size, :parent_id]
  end

  defmodule File do
    defstruct [:id, :name, :size]
  end

  def call do
    input = Elixir.File.read!("lib/day8/input") |> trim()

    data =
      input
      |> split("\n")
      |> map(&String.to_charlist/1)

    height = length(data)
    width = length(at(data, 0))

    res =
      for x <- 1..(height - 2), y <- 1..(width - 2) do
        calculate_score(data, height, width, x, y)
      end
      |> Enum.max()

    puts(res)
  end

  def calculate_score(data, height, width, x, y) do
    current_tree = data |> at(x) |> at(y)

    score_up =
      traverse(data, current_tree, x - 1, y, 0, fn
        x, _ when x == 0 -> :stop
        x, y -> {x - 1, y}
      end)

    score_down =
      traverse(data, current_tree, x + 1, y, 0, fn
        x, _ when x == height - 1 -> :stop
        x, y -> {x + 1, y}
      end)

    score_left =
      traverse(data, current_tree, x, y - 1, 0, fn
        _, y when y == 0 -> :stop
        x, y -> {x, y - 1}
      end)

    score_right =
      traverse(data, current_tree, x, y + 1, 0, fn
        _, y when y == width - 1 -> :stop
        x, y -> {x, y + 1}
      end)

    res = score_up * score_down * score_left * score_right

    # IO.inspect("#{x}, #{y}")
    # IO.inspect("score = #{res}")

    res
  end

  def traverse(data, target, x, y, score, traverser) do
    current_tree = data |> at(x) |> at(y)

    if current_tree < target do
      case traverser.(x, y) do
        {new_x, new_y} -> traverse(data, target, new_x, new_y, score + 1, traverser)
        :stop -> score + 1
      end
    else
      score + 1
    end
  end
end
