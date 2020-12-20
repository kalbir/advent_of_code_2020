defmodule Day2 do

  def solution_1(file) do
    file
      |> DataManipulation.file_to_list_of_units()
      |> Enum.map(fn x -> Day2.string_manipulation(x) end)
      |> Enum.map(fn x -> Day2.valid_password_old(x) end)
      |> Enum.count(fn x -> MapSet.size(x) > 0 end)
  end

  def solution_2(file) do
    file
      |> DataManipulation.file_to_list_of_units()
      |> Enum.map(fn x -> Day2.string_manipulation(x) end)
      |> Enum.map(fn x -> Day2.valid_password_new(x) end)
      |> Enum.count(fn {_,b} -> b == 1 end)
  end

  def string_manipulation(string) do
    [numbers, trailing, password] = string
                                     |> String.split(" ", trim: true)

    letter = String.trim_trailing(trailing, ":")

    [a, b] = String.split(numbers, "-")

    [{String.to_integer(a), String.to_integer(b)}, letter, password]
  end

  # Make "absdcofie" into a map {% "a" => n} for each letter. Then you can
  # just look up the letter you are given and get back how often it occurs.
  # I think the best way to see whether that is valid is to do a set intersection
  # between the number and a set made of the range of allowed positions (1..n) as its members.

  def valid_password_old([{a,b}, letter, string]) do
    valid_numbers = for i <- a..b, do: i

    range = MapSet.new(valid_numbers)

    letter_freq = String.graphemes(string)
                    |> letter_frequency()
                    |> Map.get(letter)


    frequency = MapSet.new([letter_freq])

    MapSet.intersection(range, frequency)
  end

  # Takes a list of the form ["a", "b", "c", "c"] and gives back a map where
  # the keys are the letters and the values are how often the letter occurs.
  def letter_frequency(list) do
    keys = Enum.uniq(list)

    count_list = for i <- keys, do: { i, count(list, i)}

    Map.new(count_list)
  end

  # Counts how many times letter appears in list
  defp count(list, letter) do
    Enum.count(list, fn x -> x == letter end)
  end

  # Part 2 functions

  # Makes a map of the position of each letter (using letter_position/1). Then looks up the
  # ath and bth letters. If those match "letter" it will add to the accumulator. For the
  # password to be value, we are looking for exactly one match, so the accumulator should end
  # up as 1. That's what we look for in the solution_2 function at the top, how many have acc
  # equal to 1. The rest of the structure is redundant so there is probably a neater way of doing it.
  def valid_password_new([{a,b}, letter, string]) do

    mappy = letter_position(string)

    Enum.map_reduce([a,b], 0, fn x, acc ->
                                    case Map.get(mappy, x) == letter do
                                      true  -> {:match, acc + 1}
                                      false -> {:empty, acc}
                                    end
                                  end)
  end

  # Takes a string of the form "abcdef" and give back a map where the keys are
  # the positions of the letters and the values are the letter in that position.
  def letter_position(string) do
    letters = string
              |> String.graphemes()

      Stream.zip(Stream.iterate(1, &(&1+1)), letters) |> Enum.into(%{})
  end
end
