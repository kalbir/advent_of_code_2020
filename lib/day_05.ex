defmodule Day05 do

  def solution_1(file) do
    DataManipulation.file_to_list(file)
      |> Enum.map(fn x -> String.codepoints(x) end)
      # The code (e.g. ["FBFBFBFLRL"] needs to break into 2 pieces on the
      # 7th character. Then run the function to give back the row and col
      # in a map, and then pass that to the seat_number func to get the 
      # list of seat numbers.
      |> Enum.map(fn x -> Enum.split(x, 7) |> find_row_col |> seat_number end)
      |> Enum.max
  end
  
  def solution_2(file) do
    DataManipulation.file_to_list(file)
      |> Enum.map(fn x -> String.codepoints(x) end)
      |> Enum.map(fn x -> Enum.split(x, 7) |> find_row_col |> seat_number end)
      # Get the list of seat numbers, order them, then use the which_seat/2
      # function to identify any pairs of seats that are not adjacent.
      |> Enum.sort
      |> Day05.which_seat([])
  end
  
  # Takes the list of letters that determines the seat (the "code") and
  # runs the binary_split function for each to get back the row and col
  # number. Puts that into a map to be consumed by seat_number.
  def find_row_col({row_code, col_code}) do
    row = binary_split(row_code, 0..127)
    col = binary_split(col_code, 0..7)

    %{"row" => row, "col" => col}
  end

  # This was a simple idea but tricky to get the details right. Iterate
  # through the list of letters ([h|t]). For each letter split the range
  # list in 2 and run the function again on the new list of letters ([t])
  # and the remaining part of the range. When you get to no more letters
  # the other part of the function matches and just returns the range.
  #
  # Some things that were tricky included:
  #   * how to treat the range and split it, in the end did it with Enums
  #   * the regex to match on (got a lot better with regexes)
  #   * what was the mid point and how to make it an integer not float.
  def binary_split(_letters = [h|t], range) do
    size = Enum.count(range) 
    mid = trunc(size / 2)
    
    {front, back} = Enum.split(range, mid)
    
    case String.match?(h, ~r/^[BR]$/)  do
      true   -> binary_split(t, back)
      false  -> binary_split(t, front) 
    end
  end

  def binary_split([], range) do
    List.first(range) 
  end

  def seat_number(%{"row" => row, "col" => col}) do
    row*8 + col
  end

  # Takes two numbers from an (ordered) list, checks if they are more than
  # 1 apart. If they are not (ie. numbers are adjacent), move on to the
  # next pair. If they are, bank that pair in the accumulator.
  def which_seat([h1, h2|t], acc) do
    diff = h2 - h1
    seat = h2 - 1

    case diff == 1 do 
     true  -> which_seat([h2|t], acc)
     false -> which_seat([h2|t], acc ++ seat)
    end
  end

  def which_seat(_list, acc) do
    acc
  end

end
