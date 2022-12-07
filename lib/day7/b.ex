defmodule Day7.B do
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
    input = Elixir.File.read!("lib/day7/input") |> trim() |> split("\n")

    registry = %{
      0 => %Directory{id: 0, name: "/", file_ids: [], size: 0}
    }

    registry = traverse(input, 0, registry, 0)
    registry = calculate_sizes(registry, 0)
    free_space = 70_000_000 - registry[0].size

    res =
      registry
      |> Map.values()
      |> filter(fn
        %Directory{} -> true
        %File{} -> false
      end)
      |> sort_by(fn object -> object.size end)
      |> find(fn object -> free_space + object.size >= 30_000_000 end)

    puts(res.size)
  end

  def traverse(input, line_index, registry, _) when line_index == length(input), do: registry

  def traverse(input, line_index, registry, reg_index) do
    line = at(input, line_index)
    current_directory = registry[reg_index]

    cond do
      line == "$ cd /" ->
        traverse(input, line_index + 1, registry, 0)

      line == "$ cd .." ->
        traverse(input, line_index + 1, registry, current_directory.parent_id)

      starts_with?(line, "$ cd") ->
        [_, _, directory_name] = line |> split(" ")
        directory_id = find(current_directory.file_ids, fn file_id -> registry[file_id].name == directory_name end)

        traverse(input, line_index + 1, registry, directory_id)

      line == "$ ls" ->
        [next_index, registry] = ls(input, line_index + 1, registry, reg_index)

        traverse(input, next_index, registry, reg_index)
    end
  end

  def ls(input, line_index, registry, _) when line_index == length(input) do
    [line_index, registry]
  end

  def ls(input, line_index, registry, parent_id) do
    line = at(input, line_index)

    cond do
      starts_with?(line, "$") ->
        [line_index, registry]

      true ->
        case split(line, " ") do
          ["dir", name] ->
            dir = %Directory{
              id: line_index,
              name: name,
              file_ids: [],
              size: 0,
              parent_id: parent_id
            }

            registry = put_in_registry(registry, dir, parent_id)

            ls(input, line_index + 1, registry, parent_id)

          [size, name] ->
            file = %File{id: line_index, name: name, size: to_integer(size)}
            registry = put_in_registry(registry, file, parent_id)

            ls(input, line_index + 1, registry, parent_id)
        end
    end
  end

  def put_in_registry(registry, object, parent_id) do
    registry
    |> Map.put(object.id, object)
    |> Map.update!(parent_id, fn parent ->
      Map.update!(parent, :file_ids, fn file_ids ->
        [object.id | file_ids]
      end)
    end)
  end

  def calculate_sizes(registry, id) do
    object = registry[id]

    case object do
      %File{} ->
        registry

      %Directory{} ->
        registry = reduce(object.file_ids, registry, fn file_id, acc -> calculate_sizes(acc, file_id) end)

        size =
          object.file_ids
          |> map(fn file_id -> registry[file_id].size end)
          |> sum()

        object = %{object | size: size}

        Map.put(registry, object.id, object)
    end
  end
end
