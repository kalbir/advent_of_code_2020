defmodule Day1 do

  # I like to put the solution in a neat package like this.

  # General idea to the solution is to create a 2-d array
  # of the lists then go through them to find ones that sum to
  # 2020, filter that one (actually two) out and multiply them
  # together.

  # I have another thought about a more simple way of doing it
  # by taking each list item, finding the remainder from 2020
  # and then seeing if that is a list member.

  def solution_1(file) do
    file
      |> DataManipulation.file_to_list_of_units()
      |> list_to_numbers()
      |> find_the_pairs()
      |> multiply()
  end

  def solution_2(file) do
    file
      |> DataManipulation.file_to_list_of_units()
      |> list_to_numbers()
      |> match_triples()
  end

  # In theory some of these could be private

  # Some difference function. Seems like I should be able to do
  # this another way but I can't find it. I need a way to tell
  # the difference between 2020 and a given number. So if I plug
  # in 2020 for n, and pass a list through as number it will do it.
  def n_minus(number, n), do: n - number

  # Turn a list of strings that look like numbers into a list of numbers.
  def list_to_numbers(list) do
    Enum.map(list, fn x -> String.to_integer(x) end)
  end

  # Go through list of numbers and find the numbers where the difference between
  # them and 2020 is in the list. i.e. there's another number in the list which will
  # add to 2020 with the one you are looking at. Nice thing is that if there is a unique
  # solution, this gives to a list with just those two numbers in it. Otherwise you'd need
  # to pair them up.

  def find_the_pairs(numbers) do
    Enum.filter(numbers, fn x -> Enum.member?(numbers, Day1.n_minus(x, 2020)) end)
  end

  # Multiply list items. Start with 1 as the acc, multiply each item with that.
  def multiply(list),  do: Enum.reduce(list, 1, fn x, acc -> x * acc end)

  # Turn the list into a 3-d array of pairs. I got a bit of help from the elixirforum
  # to get this right. Originally I wrote a function to make the a + b + c == 2020 check
  # and then did some Enum filtering with that function. This worked but took *ages* for
  # the full file. Then I did this thing with the guardrail and it works really well.
  def match_triples(list) do
    array = for a <- list, do: for b <- list, do: for c <- list, a + b + c == 2020, do: a*b*c
    List.flatten(array)
      |> Enum.uniq()
  end

  # This was the rejected function
  # def find_the_triple(triples) do
  #  Enum.filter(triples, fn {x, y, z} -> Day1.equal_2020({x,y,z}) end)
  # end

end
