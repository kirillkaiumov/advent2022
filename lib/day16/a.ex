defmodule Day16.A do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1, reverse: 1]
  import List, only: [flatten: 1, flatten: 2, replace_at: 3]
  import IO

  def call do
    input = File.read!("lib/day16/input_example") |> trim()

    vertexes =
      input
      |> split("\n")
      |> reduce(%{}, fn line, acc ->
        [vertex, edges] = split(line, "; ")
        [name, rate] = split(vertex, ", ")
        edges = split(edges, ", ")

        Map.put(acc, name, %{rate: to_integer(rate), edges: edges, is_open: false})
      end)

    res = calculate(vertexes, [], "AA", 1, 0)

    puts(res)
  end

  def calculate(_vertexes, visited_vertexes, _vertex_name, current_minute, result) when current_minute >= 31 do
    # IO.puts(visited_vertexes |> reverse() |> join(" –> "))
    # IO.puts("")
    result
  end

  def calculate(vertexes, visited_vertexes, vertex_name, current_minute, result) do
    # IO.puts("Minute: ##{current_minute}")
    # IO.puts("Vertex: #{vertex_name}")

    IO.puts(current_minute)

    current_vertex = vertexes[vertex_name]
    visited_vertexes = [vertex_name | visited_vertexes]
    new_result = update_result_after_minute(result, vertexes)
    # IO.puts("Added: #{new_result - result}")
    # IO.puts("")
    visitable_vertexes = reject(current_vertex.edges, &vertexes[&1].is_open)

    case visitable_vertexes do
      [] ->
        # IO.puts(visited_vertexes |> reverse() |> join(" –> "))
        # IO.puts("")

        if current_minute == 30 do
          new_result
        else
          vertexes = Map.put(vertexes, vertex_name, %{current_vertex | is_open: true})

          1..(30 - current_minute)
          |> reduce(new_result, fn _, acc -> update_result_after_minute(acc, vertexes) end)
        end

      _ ->
        do_not_open =
          visitable_vertexes
          |> map(fn next_vertex_name ->
            calculate(vertexes, visited_vertexes, next_vertex_name, current_minute + 1, new_result)
          end)
          |> Enum.max()

        do_open =
          visitable_vertexes
          |> map(fn next_vertex_name ->
            vertexes = Map.put(vertexes, vertex_name, %{current_vertex | is_open: true})
            new_result = update_result_after_minute(new_result, vertexes)

            calculate(vertexes, visited_vertexes, next_vertex_name, current_minute + 2, new_result)
          end)
          |> Enum.max()

        Kernel.max(do_not_open, do_open)
    end
  end

  def update_result_after_minute(result, vertexes) do
    vertexes
    |> Map.values()
    |> filter(fn vertex -> vertex.is_open end)
    |> map(fn vertex -> vertex.rate end)
    |> sum()
    |> then(&(&1 + result))
  end
end
