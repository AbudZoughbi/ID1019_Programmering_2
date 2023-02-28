defmodule Evalue do
  @type literal() :: {:num, number()}
  | {:var, atom()}
  | {:q, number(), number()}

  @type expr() :: {:add, expr(), expr()}
  | {:sub, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:div, expr(), expr()}
  | literal()

  def test  do
    env = %{a: 1, b: 2, c: 3, d: 4}
    expr = {:div, {:add, {:add, {:mul, {:num, 2}, {:var, :a}}, {:num, 3}}, {:q, 6, 2}}, {:num, 4}}
    expr1 = {:mul, {:q, 5, 2}, {:q, 4, 3}}

    eval(expr, env)
  end

  def eval({:num, num}, _) do trunc(num) end
  def eval({:var, var}, env) do Map.get(env, var) end
  def eval({:add, e1, e2}, env) do add(eval(e1, env), eval(e2, env)) end
  def eval({:sub, e1, e2}, env) do sub(eval(e1, env), eval(e2, env)) end
  def eval({:mul, e1, e2}, env) do mul(eval(e1, env), eval(e2, env)) end
  def eval({:div, e1, e2}, env) do divi(eval(e1, env), eval(e2, env)) end
  def eval({:q, e1, e2}, _) do quotient(e1,e2) end

  def add({:q, n1, m1}, {:q, n2, m2}) do divi(n1*m2 + n2*m1, m1*m2) end
  def add(e1, {:q, n, m}) do divi(e1*m + n, m) end
  def add({:q, n, m}, e2) do divi(e2*m + n, m) end
  def add(e1, e2) do e1 + e2 end

  def sub({:q, n1, m1}, {:q, n2, m2}) do divi(n1*m2 - m1*n2, m1*m2) end
  def sub(e1, {:q, n, m}) do divi(e1*m - n, m) end
  def sub({:q, n, m}, e2) do divi(e2*m - n, m) end
  def sub(e1, e2) do e1 - e2 end

  def mul({:q, n1, m1}, {:q, n2, m2}) do divi(n1*n2, m1*m2) end
  def mul({:q, n, m}, var) do divi(n*var, m) end
  def mul(var, {:q, n, m}) do divi(n*var, m) end
  def mul(e1, e2) do e1 * e2 end

  def divi({:q, n, m}, {:q, x, y}) do divi(n*y, m*x) end
  def divi({:q, n, m}, a) do divi(n, m*a) end
  def divi(a, {:q, n, m}) do divi(n, m*a) end
  def divi(a, b) do
      if(rem(a, b) == 0) do
        trunc(a / b)
      else
        x = gcd(a, b)
        if(x == 1) do
          {:q, a, b}
        else
          divi(trunc((a/x)),trunc((b/x)))
        end
      end
    end

    def quotient(e1, e2) do
    {:q, trunc(e1/(gcd(e1,e2))), trunc(e2/gcd(e1,e2))}
    end

    def gcd(x, 0) do x end
    def gcd(x, y) do gcd(y, rem(x,y)) end
end
