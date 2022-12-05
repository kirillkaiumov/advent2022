defmodule Day5.A do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1]
  import IO

  def call do
    input = File.read!("lib/day5/input")

    [stack_strings, commands] = split(input, "\n\n")

    stack_strings = split(stack_strings, "\n")
    stack_strings = slice(stack_strings, 0, length(stack_strings) - 1)
    commands = split(commands, "\n")

    stacks =
      stack_strings
      |> reduce([], fn stack_string, acc ->
        results =
          ~r/(\[\w\]|\s{3})\s?/
          |> Regex.scan(stack_string)
          |> map(fn [_, elem] -> elem end)

        acc ++ [results]
      end)
      |> then(fn stacks ->
        for i <- 0..8 do
          for k <- 0..7 do
            stacks |> Enum.at(k) |> Enum.at(i)
          end
        end
      end)
      |> map(fn stack -> reject(stack, fn elem -> elem == "   " end) end)

    res =
      commands
      |> reduce(stacks, fn command, acc ->
        [[amount], [from], [to]] = Regex.scan(~r/\d+/, command)
        amount = to_integer(amount)
        from = to_integer(from) - 1
        to = to_integer(to) - 1

        moving_blocks = acc |> at(from) |> slice(0, amount) |> Enum.reverse()

        acc
        |> List.update_at(from, fn stack -> slice(stack, amount, length(stack)) end)
        |> List.update_at(to, fn stack -> moving_blocks ++ stack end)
      end)
      |> map(fn stack -> at(stack, 0) end)

    puts(res)
  end
end
