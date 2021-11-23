defmodule DataManipulation do
  def file_to_list(file) do
    file
    |> File.read!()
    |> String.split(~r{\n}, parts: :infinity, trim: true)
  end

  def file_to_list_of_units(file) do
    file
    |> file_to_list
    |> Enum.map(fn x -> String.split(x, ~r{\t}, parts: :infinity) end)
    |> List.flatten()
  end

  def split_on_newline(file) do
    file
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.replace(&1, "\n", " "))
    |> Enum.map(&String.trim(&1, " ")) 
  end
end
