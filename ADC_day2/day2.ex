defmodule Day2 do

  # A/X = rock, 1p
  # B/Y = paper, 2p
  # C/Z = scissor, 3p

  # L = 0p, D = 3p, W = 6p

  def test do
    map = %{{"A", "X"} => 4, {"A", "Y"} => 8, {"A", "Z"} => 3,
            {"B", "X"} => 1, {"B", "Y"} => 5, {"B", "Z"} => 9,
            {"C", "X"} => 7, {"C", "Y"} => 2, {"C", "Z"} => 6}

    map2 = %{{"A", "X"} => 3, {"A", "Y"} => 4, {"A", "Z"} => 8,
            {"B", "X"} => 1, {"B", "Y"} => 5, {"B", "Z"} => 9,
            {"C", "X"} => 2, {"C", "Y"} => 6, {"C", "Z"} => 7}

    file = File.read!("C:/Users/abudz/Desktop/Skola/Kurser/Programmering_2/ADC_day2/input.txt")
    games = String.split(file, "\r\n")
    IO.inspect(games)
    x = Enum.map(games, fn games -> String.split(games, " ") end)
    IO.inspect(x)
    x = Enum.map(x, fn [opp, me] -> map[{opp, me}] end)
    Enum.sum(x)
  end

end
