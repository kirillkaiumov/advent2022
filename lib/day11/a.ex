defmodule Day11.A do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1, reverse: 1]
  import List, only: [flatten: 1, replace_at: 3]
  import IO

  def call do
    input = File.read!("lib/day11/input") |> trim()

    input
    |> split("\n\n")
    |> map(&parse_monkey/1)
    |> inspect_items(0)
    |> map(fn monkey -> monkey.inspected_count end)
    |> sort(:desc)
    |> slice(0..1)
    |> tap(fn [a, b] ->
      puts(a * b)
    end)
  end

  def parse_monkey(input) do
    [[_, items]] = Regex.scan(~r/Starting items: (.+)/, input)
    items = items |> split(",") |> map(&trim/1) |> map(&to_integer/1)

    [[_, _, operation_sign, operand]] = Regex.scan(~r/new = (.+) ([*+]) (.+)/, input)

    operation =
      cond do
        operand == "old" -> fn old -> floor(old * old / 3) end
        operation_sign == "+" -> fn old -> floor((old + to_integer(operand)) / 3) end
        operation_sign == "*" -> fn old -> floor(old * to_integer(operand) / 3) end
      end

    [[_, divisible_by]] = Regex.scan(~r/divisible by (.+)/, input)
    [[_, true_monkey]] = Regex.scan(~r/If true: throw to monkey (.+)/, input)
    [[_, false_monkey]] = Regex.scan(~r/If false: throw to monkey (.+)/, input)

    test = fn value ->
      if rem(value, to_integer(divisible_by)) == 0 do
        to_integer(true_monkey)
      else
        to_integer(false_monkey)
      end
    end

    %{
      items: items,
      operation: operation,
      test: test,
      inspected_count: 0
    }
  end

  def inspect_items(data, 20), do: data

  def inspect_items(data, round) do
    data = perform_round(data, 0)

    inspect_items(data, round + 1)
  end

  def perform_round(data, index) when index == length(data), do: data

  def perform_round(data, index) do
    monkey = at(data, index)

    data =
      reduce(monkey.items, data, fn item, acc ->
        new_item = item |> monkey.operation.()
        receiver_monkey_id = new_item |> monkey.test.()
        receiver_monkey = at(acc, receiver_monkey_id)
        new_receiver_monkey = %{receiver_monkey | items: receiver_monkey.items ++ [new_item]}

        replace_at(acc, receiver_monkey_id, new_receiver_monkey)
      end)

    monkey = %{monkey | inspected_count: monkey.inspected_count + length(monkey.items), items: []}
    data = replace_at(data, index, monkey)

    perform_round(data, index + 1)
  end
end
