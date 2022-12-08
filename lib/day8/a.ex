defmodule Day8.A do
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
        visible?(data, height, width, x, y)
      end
      |> count(& &1)

    puts(res)
    puts(res + height * 2 + width * 2 - 4)
  end

  def visible?(data, height, width, x, y) do
    current_tree = data |> at(x) |> at(y)

    visible_up = for(i <- 0..(x - 1), do: data |> at(i) |> at(y)) |> all?(&(&1 < current_tree))
    visible_down = for(i <- (x + 1)..(height - 1), do: data |> at(i) |> at(y)) |> all?(&(&1 < current_tree))
    visible_left = for(k <- 0..(y - 1), do: data |> at(x) |> at(k)) |> all?(&(&1 < current_tree))
    visible_right = for(k <- (y + 1)..(width - 1), do: data |> at(x) |> at(k)) |> all?(&(&1 < current_tree))

    visible_up || visible_down || visible_left || visible_right
  end
end
