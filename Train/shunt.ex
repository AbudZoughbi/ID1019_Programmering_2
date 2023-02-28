defmodule Shunt do

  def test do
    train = [:a, :b, :c, :d]
    desired = [:c, :b, :d, :a]
    compress(few(train, desired))
  end


  def find([], []) do [] end
  def find(xs, [y|ys]) do
    {hs, ts} = Train.split(xs, y)
    tn = length(ts)
    hn = length(hs)
    [{:one, tn+1}, {:two, hn}, {:one, -(tn+1)}, {:two, -hn} | find(Train.append(hs, ts), ys)]
  end

  def few([], []) do [] end
  def few([h|hs], [y|ys]) when h==y do few(hs, ys) end
  def few(xs, [y|ys]) do
    {hs, ts} = Train.split(xs, y)
    tn = length(ts)
    hn = length(hs)
    [{:one, tn+1}, {:two, hn}, {:one, -(tn+1)}, {:two, -hn} | few(Train.append(hs, ts), ys)]
  end

  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
      ms
    else
      compress(ns)
    end
  end

  def rules([]) do [] end
  #----rule 3/4----
  def rules([{_,0}|t]) do rules(t) end
  #----rule 1/2----
  def rules([{num, n}, {num, m}|t]) do rules([{num, n+m}|t]) end
  #onödig
  #def rules([{num1,n}, {num2, m}|t]) do [{num1, n} | rules([{num2, m}|t])] end
  def rules([h|t]) do [h| rules(t)] end

end
