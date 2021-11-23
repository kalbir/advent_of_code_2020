defmodule Day4 do

  # Turn the file into maps representing passport data.
  # Then turn each map representing passport data into a pid if it is valid or return nil if it is not valid.
  # Then count all of the pids (i.e. the non nil values)
  def solution_1(file) do
    file
      |> DataManipulation.split_on_newline()
      |> passport_data
      |> Enum.map(fn x -> valid_fields(x) end)
      |> Enum.count(fn x -> x != nil end)
  end

  # Take the set of valid passports then run each one through a function that checks that each field is valid, returning say "valid" if they are.
  # The function valid_data/1 takes the map, checks that it has the correct fields and then runs a function is_data_valid?/1 to check each field is valid.
  # Each field has its own validity check function. 
  # This solution is pretty LONG, but it is rock solid.
  def solution_2(file) do
    file
      |> DataManipulation.split_on_newline()
      |> passport_data
      |> Enum.map(fn x -> valid_data(x) end)
      |> Enum.count(fn x -> x == "valid" end)
  end


  # Take a list of strings, each string is a passport. Turn it into some maps.
  def passport_data(list) do
    list
    |> Enum.map(fn x -> String.split(x, " ") end) 
    |> Enum.map(fn y -> Enum.reduce(y, %{}, fn x, acc -> [key, value] = String.split(x, ":") 
      Map.put(acc, key, value) end) end) 
  end


  # A function with two cases. The first fires when all of the conditions are met, i.e. the map has all of those keys (the valid keys). The second condition is all other cases where we will just return nil.

  def valid_fields(map)
    when is_map_key(map, "byr")
     and is_map_key(map, "iyr")
     and is_map_key(map, "eyr")
     and is_map_key(map, "hgt")
     and is_map_key(map, "hcl")
     and is_map_key(map, "ecl") do
      Map.get(map, "pid")
  end

  def valid_fields(_map) do
    nil
  end

  def valid_data(map)
    when is_map_key(map, "byr")
     and is_map_key(map, "iyr")
     and is_map_key(map, "eyr")
     and is_map_key(map, "hgt")
     and is_map_key(map, "hcl")
     and is_map_key(map, "ecl")
     and is_map_key(map, "pid") do
       all_data_valid?(map)
    end
    
  def valid_data(_map) do
    nil
  end

  def all_data_valid?(%{"byr" => byr, "iyr" => iyr, "eyr" => eyr, "hgt" => hgt, "hcl" => hcl, "ecl" => ecl, "pid" => pid}) do
  
    case [valid_birth_year(byr), valid_issue_year(iyr), valid_exp_year(eyr), valid_height(hgt), valid_eye_colour(ecl), valid_hair(hcl), valid_pid(pid)] do
      [true, true, true, true, true, true, true] -> "valid"
      [_, _, _, _, _, _, _ ]                     -> "invalid"
    end
  end

  def valid_birth_year(year_string) do
    case String.to_integer(year_string) do
      x when x in 1920..2002 -> true
      _                      -> false
    end
  end
    
  def valid_issue_year(year_string) do
    case String.to_integer(year_string) do
      x when x in 2010..2020 -> true
      _                      -> false
    end
  end

  def valid_exp_year(exp_string) do
    case String.to_integer(exp_string) do
      x when x in 2020..2030 -> true
      _                      -> false
    end
  end
  
  def valid_height(height_string) do
    case String.split_at(height_string, -2) do
      {x, "cm"} -> String.to_integer(x) in 150..193 
      {y, "in"} -> String.to_integer(y) in 59..76
      {_, _ }   -> false
    end
  end

  def valid_eye_colour(eye_colour) do
    case eye_colour do
      x when x in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
 -> true
      _   -> false
    end
  end

  def valid_pid(pid) do
    Regex.match?(~r/^([0-9]{9}$)/, pid) 
  end

  def valid_hair(hair_colour) do
    Regex.match?(~r/^#([0-9a-f]{6}$)/, hair_colour)
  end

end
