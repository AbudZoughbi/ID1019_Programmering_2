defmodule Dinner do
  def start(n) do spawn(fn -> init(n) end) end

  def init(n) do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    #gui = Gai.start([:Arendt, :Hypatia, :Simone, :Elisabeth, :Ayn])
    Philosopher.start(n, c1, c2, "Arendt", ctrl)
    Philosopher.start(n, c2, c3, "Hypatia", ctrl)
    Philosopher.start(n, c3, c4, "Simone", ctrl)
    Philosopher.start(n, c4, c5, "Elisabeth", ctrl)
    Philosopher.start(n, c5, c1, "Ayn", ctrl)
    x = :os.system_time(:millisecond)
    wait(5, [c1, c2, c3, c4, c5], x)

  end

  def wait(0, chopsticks, x) do
    y = (:os.system_time(:millisecond) - x)/1000
    IO.inspect(y, label: "time in seconds")
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
    IO.puts("complete")
  end
  def wait(n, chopsticks, x) do
    receive do
      :done ->
        wait(n - 1, chopsticks, x)
      :abort ->
        Process.exit(self(), :kill)
    end
  end

end
