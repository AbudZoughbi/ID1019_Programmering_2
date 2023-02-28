defmodule Train do


  def test() do
    Moves.single({:one, -1}, {[:a, :b, :c], [:d], [:k, :f]})
  end

  def take(_, 0) do [] end
  def take([h|t], n) when n > 0 do [h|take(t, n-1)] end


  def drop(train, 0) do train end
  def drop([_|t], n) when n > 0 do drop(t, n-1) end

  def append([], train2) do train2 end
  def append([h|t], train2) do [h| append(t,train2)] end

  def member([], _) do false end
  def member([w|_], w) do true end
  def member([_|t], w) do member(t, w) end

  def position([w|_], w) do 1 end
  def position([_|t], w) do position(t, w) + 1 end

  def split([w|t], w) do {[], t} end
  def split([h|t], w) do
    {t, rest} = split(t, w)
    {[h|t], rest}
  end

  def main([], n) do {n, [], []} end
  def main([h|t], n) do
    case main(t, n) do
      {0, left, right} ->
          {0, [h|left], right}
      {n, left, right} ->
          {n-1, left, [h|right]}
    end
  end

end
