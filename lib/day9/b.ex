defmodule Day9.B do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1]
  import IO

  def call do
    input = File.read!("lib/day9/input") |> trim()

    acc = %{
      visited_cells: MapSet.new(),
      head_x: 0,
      head_y: 0,
      body: [
        {0, 0},
        {0, 0},
        {0, 0},
        {0, 0},
        {0, 0},
        {0, 0},
        {0, 0},
        {0, 0},
        {0, 0}
      ]
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
              fn x, y -> {x, y + 1} end
            )

          "D" ->
            do_steps(
              acc,
              steps,
              fn x, y -> {x, y - 1} end
            )

          "L" ->
            do_steps(
              acc,
              steps,
              fn x, y -> {x - 1, y} end
            )

          "R" ->
            do_steps(
              acc,
              steps,
              fn x, y -> {x + 1, y} end
            )
        end
      end)

    puts(MapSet.size(acc.visited_cells))
  end

  def find_new_coordinates(head_x, head_y, body_x, body_y) do
    cond do
      head_y - body_y == 2 ->
        cond do
          head_x < body_x -> {body_x - 1, body_y + 1}
          head_x == body_x -> {body_x, body_y + 1}
          head_x > body_x -> {body_x + 1, body_y + 1}
        end

      head_y - body_y == -2 ->
        cond do
          head_x < body_x -> {body_x - 1, body_y - 1}
          head_x == body_x -> {body_x, body_y - 1}
          head_x > body_x -> {body_x + 1, body_y - 1}
        end

      head_x - body_x == -2 ->
        cond do
          head_y < body_y -> {body_x - 1, body_y - 1}
          head_y == body_y -> {body_x - 1, body_y}
          head_y > body_y -> {body_x - 1, body_y + 1}
        end

      head_x - body_x == 2 ->
        cond do
          head_y < body_y -> {body_x + 1, body_y - 1}
          head_y == body_y -> {body_x + 1, body_y}
          head_y > body_y -> {body_x + 1, body_y + 1}
        end

      true ->
        {body_x, body_y}
    end
  end

  def do_steps(acc, 0, _), do: acc

  def do_steps(acc, steps_left, head_mover) do
    {new_head_x, new_head_y} = head_mover.(acc.head_x, acc.head_y)

    new_body = generate_new_body(acc.body, 0, new_head_x, new_head_y)

    acc = %{
      acc
      | head_x: new_head_x,
        head_y: new_head_y,
        body: new_body,
        visited_cells: MapSet.put(acc.visited_cells, at(new_body, 8))
    }

    do_steps(acc, steps_left - 1, head_mover)
  end

  def generate_new_body(body, 9, _, _), do: body

  def generate_new_body(body, index, head_x, head_y) do
    {body_x, body_y} = at(body, index)
    {new_body_x, new_body_y} = find_new_coordinates(head_x, head_y, body_x, body_y)

    new_body = List.replace_at(body, index, {new_body_x, new_body_y})

    generate_new_body(new_body, index + 1, new_body_x, new_body_y)
  end
end
