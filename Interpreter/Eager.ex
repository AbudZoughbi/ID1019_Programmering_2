defmodule Eager do
  #the sequence
  x = :foo; y = :nil; {z, _} = {:bar, :grk}; {x, {z, y}}

  def test do
    seq = [{:match, {:var, :x}, {:atm, :a}},
{:match, {:var, :f},
{:lambda, [:y], [:x], [{:cons, {:var, :x}, {:var, :y}}]}},
{:apply, {:var, :f}, [{:atm, :b}]}
]

    eval(seq)
  end

  def eval(seq) do eval_seq(seq, Env.new()) end

  #----Eval_Expr----
  def eval_expr({:atm, id}, _) do {:ok, id} end

  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil ->
        :error
      {_, str} ->
        {:ok, str}
    end
  end

  def eval_expr({:cons, he, te}, env) do
    case eval_expr(he, env) do
      :error ->
        :error
      {:ok, hs} ->
        case eval_expr(te, env) do
          :error ->
            :error
          {:ok, ts} ->
            {:ok, {hs, ts}}
        end
    end
  end

  def eval_expr({:case, expr, cls}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, str} ->
        eval_cls(cls, str, env)
    end
  end

  def eval_expr({:lambda, par, free, seq}, env) do
    case Env.closure(free, env) do
      :error ->
        :error
      closure ->
        {:ok, {:closure, par, seq, closure}}
    end
  end

  def eval_expr({:apply, expr, args}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, {:closure, par, seq, closure}} ->
        case eval_args(args, env) do
          :error ->
            :error
          {:ok, strs} ->
            env = Env.args(par, strs, closure)
            eval_seq(seq, env)
        end
    end
  end


  #----Eval_Clause----
  def eval_cls([], _, _) do
    :error
  end

  def eval_cls([{:clause, ptr, seq} | cls], str, env) do
    case eval_match(ptr, str, eval_scope(ptr, env)) do
      :fail ->
        eval_cls(cls, str, env)
      {:ok, env} ->
        eval_seq(seq, env)
      end
  end


  #----Eval_Match----
  # evaluerar nånting med nånting

  def eval_match(:ignore, _, env) do
    {:ok, env}
  end

  def eval_match({:atm, id}, id, env) do
    {:ok, env}
  end

  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
#finns inte så lägg till i env
      nil ->
        {:ok, IO.inspect(Env.add(id, str, env))}
#finns så returnera ordinarie env
      {_, ^str} ->
        {:ok, IO.inspect(env)}
#finns, men matchar inte till str
      {_, _} ->
        :fail
    end
  end

  def eval_match({:cons, hp, tp}, {hs, ts}, env) do
    case eval_match(hp, hs, env) do
      :fail ->
        :fail
      {:ok, env} ->
          eval_match(tp, ts, env)
    end
  end

  def eval_match(_, _, _) do
    :fail
  end

  #----Eval_Args----
  def eval_args(args, env) do
    eval_args(args, env, [])
  end

  def eval_args([], _, strs) do {:ok, Enum.reverse(strs)} end
  def eval_args([expr | exprs], env, strs) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, str} ->
        eval_args(exprs, env, [str | strs])
    end
  end

  #----Eval_Seq----

  # returnerar en env utan alla varibler som ges i lista
  def eval_scope(ptr, env) do  Env.remove(extract_vars(ptr), env) end

  # det sista i sekvensen som körs, alltså endast expression i slutet av seq
  def eval_seq([exp], env) do eval_expr(exp, env) end

  def eval_seq([{:match, ptr, exp} | seq], env) do
    case eval_expr(exp, env) do
      :error ->
        :error
      {:ok, str} ->
        env = eval_scope(ptr, env)
        case eval_match(ptr, str, env) do
          :fail ->
            :error

          {:ok, env} ->
            eval_seq(seq, env)
        end
    end
  end

  def extract_vars(pattern) do extract_vars(pattern, []) end

  def extract_vars({:atm, _}, vars) do vars end
  def extract_vars(:ignore, vars) do vars end
  def extract_vars({:var, var}, vars) do [var | vars] end
  def extract_vars({:cons, h, t}, vars) do extract_vars(t, extract_vars(h, vars)) end

end
