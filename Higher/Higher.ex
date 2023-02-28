defmodule High do

  def double([]) do [] end
  def double([h | t]) do
    [h * 2 | double(t)]
  end

  def five([]) do [] end
  def five([h | t]) do
    [h + 5 | five(t)]
  end

  def animal([]) do [] end
  def animal([h | t]) do
    if h == :dog do
      [:fido | animal(t)]
    else
      [h | animal(t)]
    end
  end

  def double_five_animal([], _) do [] end
  def double_five_animal([h | t], atom) do
    case atom do
      :double -> [h * 2 | double_five_animal(t, atom)]
      :five -> [h + 5 | double_five_animal(t, atom)]
      :animal ->
        if h == :dog do
          [:fido | double_five_animal(t, atom)]
        else
          [h | double_five_animal(t, atom)]
        end
    end
  end

  #---------Func as data------------
  # f = fn(x) -> x*2 end
  # g = fn(x) -> x+5 end
  # h = fn(x) -> if x == :dog do :fido; else x end end

  #---------Func as argument------------
  def apply_to_all([], _) do [] end
  def apply_to_all([h | t], func) do
    [func.(h) | apply_to_all(t, func)]
  end

  #---------reducing a list------------
  def sum([]) do 0 end
  def sum([h | t]) do h + sum(t) end

  def prod([]) do 1 end
  def prod([h | t]) do h * prod(t) end

  def fold_right([], baseV, _) do baseV end
  def fold_right([h | t], baseV, func) do
    func.(h, fold_right(t, baseV, func))
  end

  def fold_left([], acc, _) do acc end
  def fold_left([h | t], acc, func) do
    fold_left(t, func.(h, acc), func)
  end

  #--------Filter out the good ones -----------
  def odd([]) do [] end
  def odd([h | t]) do
    if rem(h, 2) == 1 do
      [h | odd(t)]
    else
      odd(t)
    end
  end

  def filter([], _) do [] end
  def filter([h | t], func) do
    if func.(h) do
      [h | filter(t, func)]
    else
      filter(t, func)
    end
  end


end
