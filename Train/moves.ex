defmodule Moves do

  def single({_, 0}, {main, one, two}) do {main, one, two} end

  def single({:one, n}, {main, one, two}) when n > 0 do
    {_, staying, goingOne} = Train.main(main, n)
    {staying, Train.append(goingOne, one), two}
  end

  def single({:one, n}, {main, one, two}) when n < 0 do
    goingMain = Train.take(one, -n)
    {Train.append(main, goingMain), Train.drop(one, -n), two}
  end

  def single({:two, n}, {main, one, two}) when n > 0 do
    {_, staying, goingTwo} = Train.main(main, n)
    {staying, one, Train.append(goingTwo, two)}
  end

  def single({:two, n}, {main, one, two}) when n < 0 do
    goingMain = Train.take(two, -n)
    {Train.append(main, goingMain), one, Train.drop(two, -n)}
  end

  def sequence([], state) do [state] end
  def sequence([move|rest], state) do
    [state | sequence(rest, single(move, state))]
  end

end
