defmodule Hanoi do

  def test(n) do
    hanoi(n, :from, :help, :finish)
  end

  def hanoi(0, _, _, _) do [] end
  def hanoi(n, from, help, finish) do
    hanoi(n-1, from, finish, help) ++
    [{:move, from, finish}] ++
    hanoi(n-1, help, from, finish)
  end

end
