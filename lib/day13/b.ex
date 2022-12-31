defmodule Day13.B do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1, reverse: 1]
  import List, only: [flatten: 1, flatten: 2, replace_at: 3]
  import IO

  def call do
    input = File.read!("lib/day13/input") |> trim()

    sorted_list =
      input
      |> split("\n\n")
      |> reduce([], fn line, acc ->
        [a, b] = split(line, "\n")
        {a, _} = Code.eval_string(a)
        {b, _} = Code.eval_string(b)

        [a, b | acc]
      end)
      |> sort(fn a, b -> compare(a, b) == :left end)

    {_, a_position} =
      sorted_list
      |> with_index()
      |> find(fn {elem, _} -> compare([[2]], elem) == :left end)

    {_, b_position} =
      sorted_list
      |> with_index()
      |> find(fn {elem, _} -> compare([[6]], elem) == :left end)

    puts((a_position + 1) * (b_position + 2))
  end

  def compare([], []), do: :equal
  def compare([], _b), do: :left
  def compare(_a, []), do: :right

  def compare(a, b) do
    [elem_a | a_tail] = a
    [elem_b | b_tail] = b

    {elem_a, elem_b} =
      cond do
        is_list(elem_a) && is_list(elem_b) -> {elem_a, elem_b}
        is_list(elem_a) -> {elem_a, [elem_b]}
        is_list(elem_b) -> {[elem_a], elem_b}
        true -> {elem_a, elem_b}
      end

    cond do
      is_list(elem_a) && is_list(elem_b) ->
        case compare(elem_a, elem_b) do
          :left -> :left
          :right -> :right
          :equal -> compare(a_tail, b_tail)
        end

      elem_a < elem_b ->
        :left

      elem_a > elem_b ->
        :right

      elem_a == elem_b ->
        compare(a_tail, b_tail)
    end
  end
end
