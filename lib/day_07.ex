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

  def solution_2(file) do
    file
      |> DataManipulation.file_to_list
      |> Enum.map(fn x -> String.split(x) end)
  end

  # This will make the list of bags that can contain $bag
  # We'll use in in `a_function` to pass different bags of one layer
  # in and get the bags they are contained in (i.e. the next layer)

  @doc """
  Takes a string for the name of the bag that is on the inside, and a list of tuples of the form `{"bag_1", "bag_2"}`, where `bag_2` contains `bag_1`..
  Returns a list of bags that contain `bag`.

  ## Examples
      iex> map = [
  {"bw", "lr"},
  {"my", "lr"},
  {"bw", "do"},
  {"my", "do"},
  {"sg", "bw"},
  {"sg", "my"},
  {"fb", "my"},
  {"dol", "sg"},
  {"vp", "sg"},
  {"fb", "dol"},
  {"dobl", "dol"},
  {"fb", "vp"},
  {"dobl", "vp"},
  {"none", "fb"},
  {"none", "dobl"}
      ]
      iex> Day07.find_containing_bags("sg", map) 
      ["bw", "my"]
  """
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


  # Part 2 function. Make the map, key is the "layer", value is the
  # set of info we need to compute that layer. i.e. the lists that
  # are needed for that layer.
  
  def layer_map(struct, list_of_bags) do
    Enum.filter(struct, fn x -> Enum.filter(list_of_bags, fn y -> List.first(x) == y end) != [] end) 
  end

  # Takes the output of `layer map` and works out what the sum of all bags
  # at that layer is. Needs to be multiplied by the higher layer number.
  def sum_in_a_layer(list_of_relations) do
     Enum.filter(list_of_relations, fn x -> numbers_only(x) end)
  end

  defp numbers_only(thing) do 
    case thing do
      thing when is_integer(thing) -> true
      _                            -> false
    end
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

  # Data munge part 2. Will look up if there is something better here.
  def number_munge([a, b, _c, _d, e, f, g, _h, i, j, k, _l, m, n, o, _p, q, r, s, _t]) do
    ["#{a} #{b}", String.to_integer(e), "#{f} #{g}", String.to_integer(i), "#{j} #{k}", String.to_integer(m), "#{n} #{o}", String.to_integer(q), "#{r} #{s}"]
  end
  
  def number_munge([a, b, _c, _d, e, f, g, _h, i, j, k, _l, m, n, o, _p]) do
    ["#{a} #{b}", String.to_integer(e), "#{f} #{g}", String.to_integer(i), "#{j} #{k}", String.to_integer(m), "#{n} #{o}"]
  end
  
  def number_munge([a, b, _c, _d, e, f, g, _h, i, j, k, _l]) do
    ["#{a} #{b}", String.to_integer(e), "#{f} #{g}", String.to_integer(i), "#{j} #{k}"]
  end
  
  def number_munge([a, b, _c, _d, e, f, g, _h]) do
    ["#{a} #{b}", String.to_integer(e), "#{f} #{g}"]
  end

  def number_munge([a, b, _c, _d, _e, _f, _g]) do
    ["#{a} #{b}", "0"]
  end
end
