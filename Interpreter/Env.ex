defmodule Env do

  def new() do [] end

  def add(id, str, env) do [{id, str} | env] end

  def lookup(_, []) do nil end
  def lookup(id, [{id, str} | _]) do {id, str} end
  def lookup(id, [_|t]) do lookup(id, t) end

  def remove(_, nil) do [] end
  def remove(_, []) do [] end
  def remove([], env) do env end
  def remove([ids | t], env) do remove(ids, remove(t, env)) end
  def remove(ids, [{ids, _} | t]) do t end
  def remove(ids, [h | t]) do [h | remove(ids, t)] end

  def closure(keyss, env) do
    List.foldr(keyss, [], fn(key, acc) ->
      case acc do
        :error -> :error

        cls ->
          case lookup(key, env) do
            {key, value} ->
              [{key, value} | cls]

            nil -> :error
          end
      end
    end)
  end

  def args(pars, args, env) do
    List.zip([pars, args]) ++ env
  end
end
