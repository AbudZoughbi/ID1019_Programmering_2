defmodule Derivative do
  @type literal() :: {:num, number()}
                    | {:var, atom()}

  @type expr() :: {:add, expr(), expr()}
                  | {:mul, expr(), expr()}
                  | literal()
                  | {:exp, expr(), literal()}
                  | {:ln, expr()}
                  | {:div, expr(), expr()}
                  | {:sqrt, expr()}
                  | {:sin, expr()}
                  | {:cos, expr()}


      def test1() do
        e = {:add,
        {:mul, {:num, 2}, {:var, :x}},
        {:num, 4}}

        d = deriv(e, :x)
        c = calc(d, :x, 5)
        IO.write("expression: #{pprint(e)}\n")
        IO.write("derivative: #{pprint(d)}\n")
        IO.write("simplified: #{pprint(simplify(d))}\n")
        IO.write("calculated: #{pprint(simplify(c))}\n")
        :ok
      end

      def test2() do
        e = {:add,
        {:exp, {:var, :x}, {:num, 3}},
        {:num, 4}}

        d = deriv(e, :x)
        c = calc(d, :x, 4)
        IO.write("expression: #{pprint(e)}\n")
        IO.write("derivative: #{pprint(d)}\n")
        IO.write("simplified: #{pprint(simplify(d))}\n")
        IO.write("calculated: #{pprint(simplify(c))}\n")
        :ok
      end

      def test_ln() do
        e = {:ln, {:var, :x}}
        d = deriv(e, :x)

        IO.write("expression: #{pprint(e)}\n")
        IO.write("derivative: #{pprint(d)}\n")
        IO.write("simplified: #{pprint(simplify(d))}\n")
      end

      def test_div() do
        e = {:div, {:num, 1}, {:var, :x}}
        d = deriv(e, :x)

        IO.write("expression: #{pprint(e)}\n")
        IO.write("derivative: #{pprint(d)}\n")
        IO.write("simplified: #{pprint(simplify(d))}\n")
      end

      def test_sqrt do
        e = {:sqrt, {:var, :x}}
        d = deriv(e, :x)

        IO.write("expression: #{pprint(e)}\n")
        IO.write("derivative: #{pprint(d)}\n")
        IO.write("simplified: #{pprint(simplify(d))}\n")
      end

      def test_sin do
        e = {:sin, {:var, :x}}
        d = deriv(e, :x)

        IO.write("expression: #{pprint(e)}\n")
        IO.write("derivative: #{pprint(d)}\n")
        IO.write("simplified: #{pprint(simplify(d))}\n")
      end

      def test_cos do
        e = {:cos, {:var, :x}}
        d = deriv(e, :x)

        IO.write("expression: #{pprint(e)}\n")
        IO.write("derivative: #{pprint(d)}\n")
        IO.write("simplified: #{pprint(simplify(d))}\n")
      end

  #---------Deriv----------
  def deriv({:num, _}, _) do
   {:num, 0}
  end

  def deriv({:var, v}, v) do
    {:num, 1}
  end

  def deriv({:var, _}, _) do
    {:num, 0}
  end

  def deriv({:mul, e1, e2}, v) do
    {:add, {:mul, deriv(e1, v), e2}, {:mul, e1, deriv(e2, v)}}
  end

  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end

  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n-1}}},
      deriv(e, v)}
  end

  #----------deriv--ln----------
  def deriv({:ln, {:var, v}}, v) do {:div, {:num, 1}, {:var, v}} end
  #----------deriv--div--------
  def deriv({:div, {:num, n}, {:var, v}}, v) do {:div, {:num, -1 * n}, {:exp, {:var, v}, {:num, 2}}}  end
  #----------deriv--sqrt--------
  def deriv({:sqrt, e}, v) do {:div, deriv(e,v), {:mul, {:num, 2}, {:sqrt, e}}}  end
  #----------deriv--sin---------
  def deriv({:sin, e}, _) do {:cos, e}  end
  #----------deriv--cos---------
  def deriv({:cos, e}, _) do {:mul,{:num, -1}, {:sin, e}}  end

  #----------Calc----------
  def calc({:num, n}, _, _) do
    {:num, n}
  end

  def calc({:var, v}, v, n) do
    {:num, n}
  end

  def calc({:var, v}, _, _) do
    {:var, v}
  end

  def calc({:add, e1, e2}, v, n) do
    {:add, calc(e1, v, n), calc(e2, v, n)}
  end

  def calc({:mul, e1, e2}, v, n) do
    {:mul, calc(e1, v, n), calc(e2, v, n)}
  end

  def calc({:exp, e1, e2}, v, n) do
    {:exp, calc(e1, v, n), calc(e2, v, n)}
  end
  #----------Print---------
  def pprint({:num, n}) do
    "#{n}"
  end

  def pprint({:var, v}) do
    "#{v}"
  end

  def pprint({:add, e1, e2}) do
    "(#{pprint(e1)} + #{pprint(e2)})"
  end

  def pprint({:mul, e1, e2}) do
    "#{pprint(e1)} * #{pprint(e2)}"
  end

  def pprint({:exp, e1, e2}) do
    "(#{pprint(e1)} ^ #{pprint(e2)})"
  end

  #-----------pprint-------------------
  def pprint({:ln, e}) do "(ln(#{pprint(e)}))"  end
  def pprint({:div, e1, e2}) do "(#{pprint(e1)} / #{pprint(e2)})" end
  def pprint({:sqrt, e}) do "sqrt(#{pprint(e)})"  end
  def pprint({:sin, e}) do "sin(#{pprint(e)})" end
  def pprint({:cos, e}) do "cos(#{pprint(e)})" end
  #---------simplify---------
  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end

  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end

  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end

  def simplify({:div, e1, e2}) do simplify_div(simplify(e1), simplify(e2))  end

  def simplify(e) do
    e
  end

  def simplify_add({:num, 0}, e2) do
    e2
  end

  def simplify_add(e1, {:num, 0}) do
    e1
  end

  def simplify_add({:num, n1}, {:num, n2}) do
    {:num, n1+n2}
  end

  def simplify_add(e1, e2) do
    {:add, e1, e2}
  end

  def simplify_mul({:num, 0}, _) do
    {:num, 0}
  end

  def simplify_mul(_, {:num, 0}) do
    {:num, 0}
  end

  def simplify_mul({:num, 1}, e2) do
    e2
  end

  def simplify_mul(e1, {:num, 1}) do
    e1
  end

  def simplify_mul({:num, n1}, {:num, n2}) do
    {:num, n1*n2}
  end

  def simplify_mul(e1, e2) do
    {:mul, e1, e2}
  end

  def simplify_exp(_, {:num, 0}) do
    {:num, 1}
  end

  def simplify_exp(e1, {:num, 1}) do
    e1
  end

  def simplify_exp({:num, n1}, {:num, n2}) do
    {:num, :math.pow(n1, n2)}
  end

  def simplify_exp(e1, e2) do
    {:exp, e1, e2}
  end

  def simplify_div(e1, e2) do {:div, e1, e2}  end

end
