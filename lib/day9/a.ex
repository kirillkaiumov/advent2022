defmodule Day9.A do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1]
  import IO

  def call do
    input = File.read!("lib/day9/input") |> trim()

    acc = %{
      visited_cells: MapSet.new(),
      head_x: 0,
      head_y: 0,
      tail_x: 0,
      tail_y: 0
    }

    acc =
      input
      |> split("\n")
      |> map(fn line ->
        [dir, number] = split(line, " ")

        {dir, to_integer(number)}
      end)
      |> reduce(acc, fn {direction, steps}, acc ->
        case direction do
          "U" ->
            do_steps(
              acc,
              steps,
              fn x, y -> {x, y + 1} end,
              fn
                head_x, head_y, _tail_x, tail_y when abs(head_y - tail_y) > 1 -> {head_x, tail_y + 1}
                _head_x, _head_y, tail_x, tail_y -> {tail_x, tail_y}
              end
            )

          "D" ->
            do_steps(
              acc,
              steps,
              fn x, y -> {x, y - 1} end,
              fn
                head_x, head_y, _tail_x, tail_y when abs(head_y - tail_y) > 1 -> {head_x, tail_y - 1}
                _head_x, _head_y, tail_x, tail_y -> {tail_x, tail_y}
              end
            )

          "L" ->
            do_steps(
              acc,
              steps,
              fn x, y -> {x - 1, y} end,
              fn
                head_x, head_y, tail_x, _tail_y when abs(head_x - tail_x) > 1 -> {tail_x - 1, head_y}
                _head_x, _head_y, tail_x, tail_y -> {tail_x, tail_y}
              end
            )

          "R" ->
            do_steps(
              acc,
              steps,
              fn x, y -> {x + 1, y} end,
              fn
                head_x, head_y, tail_x, _tail_y when abs(head_x - tail_x) > 1 -> {tail_x + 1, head_y}
                _head_x, _head_y, tail_x, tail_y -> {tail_x, tail_y}
              end
            )
        end
      end)

    puts(MapSet.size(acc.visited_cells))
  end

  def do_steps(acc, 0, _, _), do: acc

  def do_steps(acc, steps_left, head_mover, tail_mover) do
    {new_head_x, new_head_y} = head_mover.(acc.head_x, acc.head_y)
    {new_tail_x, new_tail_y} = tail_mover.(new_head_x, new_head_y, acc.tail_x, acc.tail_y)

    acc = %{
      acc
      | head_x: new_head_x,
        head_y: new_head_y,
        tail_x: new_tail_x,
        tail_y: new_tail_y,
        visited_cells: MapSet.put(acc.visited_cells, {new_tail_x, new_tail_y})
    }

    do_steps(acc, steps_left - 1, head_mover, tail_mover)
  end
end
