defmodule Day3 do

  # For the part 2 solution I added {up, right} as a way of showing the
  # vector we are moving along. Then I ran this function for each vector and
  # did the product of the results. This was inefficient computationally as I
  # load the file twice for each solution. I could probably refactor to load the
  # file once for the whole thing.
  def solution_1(file, {up, right}) do
    file
      |> DataManipulation.file_to_list_of_units()
      |> coordinate_map()
      |> tree_collection(file, {up, right})
  end

  # Make a map like {a,b} => tree for each coordinate.
  # Select each coordinate by adding (3,1)
  # Make a list of trees and misses, count the trees
  # Tricky bit is the mod arithmetic for extra bits. Thinking of
  # something like do the number mod width

  # Break each string "....#.###.." intro graphemes.
  # Give each string graphemes list a row by making it a map with the row as key.
  # Take that and turn it into a single map of all the coordinates by making a map
  # of each grapheme and it's column, then mergin that with the rows using the reduce.
  def coordinate_map(list) do
    break = Enum.map(list, fn x -> String.graphemes(x) end)

    {_, coordinate_map} = Stream.zip(Stream.iterate(0, fn x -> x+1 end), break)
                            |> Enum.into(%{})
                            |> Enum.map_reduce(%{}, fn x, acc -> {"ok", Map.merge(coordinates(x), acc)} end)
    coordinate_map
  end

  # Takes a list of graphemes [".", ".", "#", etc] and a number representing the row.
  # Gives back a set of coordinates for each of the positions in that string.
  def coordinates({n, treelist}) do
    Stream.zip(Stream.iterate({n,0}, fn {x,y} -> {x, y+1} end), treelist)
      |> Enum.into(%{})
  end

  def move(map, {a,b}) do
    Map.get(map, {a+1, b+3})
  end

  def tree_collection(map, file, {up, right}) do
    road_length = DataManipulation.file_to_list_of_units(file)

    road_list = Stream.zip(Stream.iterate({0,0}, fn {x,y} -> {x+up, y+right} end), road_length)
                  |> Enum.into([])
                  |> Enum.map(fn {a,_b} -> a end)

    {_, path} = Enum.map_reduce(road_list, [], fn {k, v}, acc -> {{k+up, Integer.mod(v+right, 31)}, acc ++ [Map.get(map, {k+up, Integer.mod(v+right, 31)})]} end)

    Enum.count(path, fn x -> x == "#" end)
  end
end
