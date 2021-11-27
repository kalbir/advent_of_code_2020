defmodule Day06 do

  def solution_1(file) do
    DataManipulation.split_on_newline(file)
      |> group_uniq_answers
      |> Enum.sum
  end
  
  # This was messy. I think there is probably a better way of doing it.
  # What I aimed to do was build a map for each group. The map shows
  # how many people in the group answered each question (e.g. "a" => 4)
  # Then I made a tuple with that map and the number of people in the 
  # group. I thought then it would be easy to find "question everyone
  # answered" by matching # people in group with the number that answered.
  # It was _relatively_ easy but it got messy along the way with the 
  # data structures.
  # So we have three steps:
  # 1. Format the data into the {#, map} tuple.
  # 2. Find all the questions that have # answers (that actually came out
  # quite elegant with `process_map`
  # 3. Count and sum it all up.
  # I imagine there are neater solutions, but this is what I got. And it 
  # is fast
  def solution_2(file) do
    DataManipulation.split_on_newline(file)
    |> Day06.reformat_data
    |> Enum.map(fn x -> Day06.process_map(x) |> Enum.count end)
    |> Enum.sum
  end

  # We're receiving an input like `["abc", "ab bc", "a a a a"]` where each
  # of the strings represents a group of answers. Here what we wanted
  # to work out is how many unique answers were given in a group. So we
  # turn each string into a list of the individual letters (codepoints),
  # remove the spaces, flatten each list and count how many uniq letters
  # there are in the list. This gives us the unique answers per group.
  def group_uniq_answers(list) do
    Enum.map(list, fn x -> String.codepoints(x)
        |> Enum.filter(fn x -> x != " " end) 
        |> List.flatten
        |> Enum.uniq
        |> Enum.count
    end)
  end
  
  def group_same_answers(list) do
    Enum.map(list, fn x -> String.split(x, " ") end)
  end

  # Horrible function. Need to get it so that I can count how many
  # times each letter has been said. When that count = the number of
  # people in the group, that means everyone guessed it.
  def reformat_data(list) do
    group_same_answers(list)
      |> Enum.map(fn x -> {Enum.count(x), x} end) # count how many people gave answers and add to the tuple
      |> Enum.map( fn {a,b} -> {a, Enum.map(b, fn y -> String.split(y, "", trim: true) end) |> List.flatten} end) 
      |> Enum.map(fn {a, x} -> {a, Day06.map_letter_frequency(x)} end) # turn the list of letters into a map of letter frequencies
  end

  # Takes the map of each groups letter frequency and matches against the number in the group. If num in group = freq everyone answered that question. 
  def process_map({number, letter_freq_map}) do 
    Enum.reduce(letter_freq_map, %{}, fn {a,b}, acc -> case b == number do
        true ->  Map.put(acc, a, b)
        false -> acc
      end
    end)
  end
 
  # Will map the frequency of any items in a list, e.g. ["a","b","c"] 
  # will go to %{"a" => 1, "b" => 1, "c" => 1}
  def map_letter_frequency(list) do
    Enum.reduce(list, %{}, fn letter, acc -> Map.update(acc, letter, 1, &(&1 + 1)) end)
  end
end
