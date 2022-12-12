defmodule Day12.A do
  import Enum, except: [split: 2]
  import String, except: [slice: 2, slice: 3, at: 2, length: 1, reverse: 1]
  import List, only: [flatten: 1, replace_at: 3]
  import IO

  def call do
    input = File.read!("lib/day12/input") |> trim()

    ress =
      for j <- 0..40 do
        row = j
        col = 0
        end_col = 158

        data =
          input
          |> split("\n")
          |> map(&String.to_charlist/1)

        data = matrix_replace_at(data, row, end_col, ?z)
        data = matrix_replace_at(data, row, col, ?a)

        res_matrix =
          for _i <- 0..(length(data) - 1) do
            for _k <- 0..(length(at(data, 0)) - 1) do
              1_000_000
            end
          end
          |> matrix_replace_at(row, col, 0)

        queue = [{row, col}]

        res_matrix = traverse_matrix(data, res_matrix, queue)

        res_matrix |> at(20) |> at(end_col)

        # back_res =
        #   for _i <- 0..(length(data) - 1) do
        #     for _k <- 0..(length(at(data, 0)) - 1) do
        #       "."
        #     end
        #   end

        # back_res = traverse_back(res_matrix, row, end_col, back_res)

        # for i <- 0..(length(data) - 1) do
        #   for k <- 0..(length(at(data, 0)) - 1) do
        #     write(back_res |> at(i) |> at(k))
        #   end

        #   puts("")
        # end
      end

    require IEx
    IEx.pry()
  end

  def matrix_replace_at(matrix, row, col, value) do
    replace_at(matrix, row, replace_at(at(matrix, row), col, value))
  end

  def traverse_matrix(_data, res_matrix, []), do: res_matrix

  def traverse_matrix(data, res_matrix, queue) do
    [{row, col} | queue] = queue
    res_cell = res_matrix |> at(row) |> at(col)
    data_cell = data |> at(row) |> at(col)

    {queue, res_matrix} =
      case explore_direction(data, res_matrix, row - 1, col, res_cell, data_cell) do
        :error ->
          {queue, res_matrix}

        res_matrix ->
          queue = queue ++ [{row - 1, col}]
          {queue, res_matrix}
      end

    {queue, res_matrix} =
      case explore_direction(data, res_matrix, row + 1, col, res_cell, data_cell) do
        :error ->
          {queue, res_matrix}

        res_matrix ->
          queue = queue ++ [{row + 1, col}]
          {queue, res_matrix}
      end

    {queue, res_matrix} =
      case explore_direction(data, res_matrix, row, col + 1, res_cell, data_cell) do
        :error ->
          {queue, res_matrix}

        res_matrix ->
          queue = queue ++ [{row, col + 1}]
          {queue, res_matrix}
      end

    {queue, res_matrix} =
      case explore_direction(data, res_matrix, row, col - 1, res_cell, data_cell) do
        :error ->
          {queue, res_matrix}

        res_matrix ->
          queue = queue ++ [{row, col - 1}]
          {queue, res_matrix}
      end

    traverse_matrix(data, res_matrix, queue)
  end

  def explore_direction(_data, _res_matrix, _row, _col, _cur_res_cell, ?E), do: :error

  def explore_direction(data, res_matrix, row, col, cur_res_cell, cur_data_cell) do
    if row >= 0 && col >= 0 && at(data, row) do
      data_cell = data |> at(row) |> at(col)
      new_res_cell = res_matrix |> at(row) |> at(col)

      if new_res_cell && data_cell <= cur_data_cell + 1 && cur_res_cell + 1 < new_res_cell do
        matrix_replace_at(res_matrix, row, col, cur_res_cell + 1)
      else
        :error
      end
    else
      :error
    end
  end

  def traverse_back(_res_matrix, 21, 0, back_res), do: back_res

  def traverse_back(res_matrix, row, col, back_res) do
    value = res_matrix |> at(row) |> at(col)

    cond do
      res_matrix |> at(row - 1) && res_matrix |> at(row - 1) |> at(col) == value - 1 ->
        back_res = matrix_replace_at(back_res, row - 1, col, "#")
        traverse_back(res_matrix, row - 1, col, back_res)

      res_matrix |> at(row + 1) && res_matrix |> at(row + 1) |> at(col) == value - 1 ->
        back_res = matrix_replace_at(back_res, row + 1, col, "#")
        traverse_back(res_matrix, row + 1, col, back_res)

      res_matrix |> at(row) && res_matrix |> at(row) |> at(col - 1) == value - 1 ->
        back_res = matrix_replace_at(back_res, row, col - 1, "#")
        traverse_back(res_matrix, row, col - 1, back_res)

      res_matrix |> at(row) && res_matrix |> at(row) |> at(col + 1) == value - 1 ->
        back_res = matrix_replace_at(back_res, row, col + 1, "#")
        traverse_back(res_matrix, row, col + 1, back_res)

      true ->
        back_res
    end
  end
end
