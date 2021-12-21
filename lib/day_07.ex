defmodule Day07 do

  # Okay this is pretty mad. The broad idea is we're doing this in layers.
  # So you go through the list and look for all the bags that contain 
  # "shiny gold" bags, add them to an accumulator (that's what `a_function`)
  # does. Then you take each bag in the accumulator, and go through the
  # list to find all the bags that contain those, add them to the acc.
  # Then do the same on the new layer of bags that you added. That's the
  # iterative aspect of `a_function`. Eventually we assume all the lists
  # of bags will end and we'll have an empty layer.
  # On top of that the `data_munge` is a real mess but I couldn't 
  # immediately think of a better way of doing that.
  def solution_1(file) do
    file
       |> DataManipulation.file_to_list
       |> Enum.map(fn x -> String.split(x) end)
       |> Enum.map(fn x -> Day07.data_munge(x) end)
       |> List.flatten
       |> Day07.a_function
       |> Enum.uniq
       |> Enum.count
  end

  # This will make the list of bags that can contain $bag
  # We'll use in in `a_function` to pass different bags of one layer
  # in and get the bags they are contained in (i.e. the next layer)
  def find_containing_bags(bag, struct) do
    Enum.filter(struct, fn {a, _} -> a == bag end)
      |> Enum.map(fn {_, b} -> b end)
  end


  # It's something like a map reduce. You want to keep extending this
  # list of the outer bags. So you go through the first case, with 
  # "shiny gold", and get back the next layer of bags. Then for each
  # of the bags in that layer, you go and get the next layer and so on.
  # Use the accumulator (`meta_list`) to keep track of all the bags we have seen so
  # far. 
  def a_function(map) do
    list = find_containing_bags("shiny gold", map)
    
    a_function(list, map, list) 
  end

  def a_function([], _map, meta_list) do
    meta_list
  end

  def a_function(list_of_bags, map, meta_list) do
    next_layer = Enum.reduce(list_of_bags, [], fn x, acc -> Day07.find_containing_bags(x, map) ++ acc end) 
    |> Enum.uniq

    total_layers = meta_list ++ next_layer
    a_function(next_layer, map, total_layers)
  end

  # Function to turn the string into something mangeable. OMG. 
  def data_munge([a, b, _c, _d, _e, f, g, _h, _i, j, k, _l, _m, n, o, _p, _q, r, s, _t]) do
    [{"#{f} #{g}","#{a} #{b}"}, {"#{j} #{k}", "#{a} #{b}"}, {"#{n} #{o}", "#{a} #{b}"}, {"#{r} #{s}", "#{a} #{b}"}]
  end
  
  def data_munge([a, b, _c, _d, _e, f, g, _h, _i, j, k, _l, _m, n, o, _p]) do
    [{"#{f} #{g}","#{a} #{b}"}, {"#{j} #{k}", "#{a} #{b}"}, {"#{n} #{o}", "#{a} #{b}"}]
  end
  
  def data_munge([a, b, _c, _d, _e, f, g, _h, _i, j, k, _l]) do
    [{"#{f} #{g}","#{a} #{b}"}, {"#{j} #{k}", "#{a} #{b}"}]
  end
  
  def data_munge([a, b, _c, _d, _e, f, g, _h]) do
    [{"#{f} #{g}","#{a} #{b}"}]
  end

  def data_munge([a, b, _c, _d, _e, _f, _g]) do
    [{"none","#{a} #{b}"}]
  end
end
