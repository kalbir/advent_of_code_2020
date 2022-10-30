defmodule Day08 do

  def solution_1(file) do
    y = DataManipulation.file_to_list(file)
         |> Enum.map(fn x -> String.split(x, " ", parts: :infinity) end)
         |> Enum.with_index()

      some_function(y, Enum.at(y, 0), 0, [])
  end

  def some_function(list, instruction, count, items) do
    case instruction do
      {["nop", _], pos} ->
        case Enum.member?(items, pos) do
          true  -> count
          false ->
            new_pos = pos + 1
            some_function(list, Enum.at(list, new_pos), count, [pos | items])
        end

      {["acc", n], pos} ->
        case Enum.member?(items, pos) do
          true  -> count
          false ->
            yacc = String.to_integer(n) + count
            new_pos = pos + 1
            some_function(list, Enum.at(list, new_pos), yacc, [pos | items])
        end

      {["jmp", m], pos} ->
        case Enum.member?(items, pos) do
          true  -> count
          false ->
            new_pos = String.to_integer(m) + pos
            some_function(list, Enum.at(list, new_pos), count, [pos | items])
        end
    end
  end
end
