defmodule Philosopher do

  @dream 800
  @eat 100
  @timeout 1000

  def start(hunger, right, left, name, ctrl) do
    spawn_link(fn -> init(hunger, right, left, name, ctrl) end)
  end


  def init(hunger, right, left, name, ctrl) do
    gui = Gui.start(name)
    dreaming(hunger, right, left, name, ctrl, gui)
  end

  defp dreaming(0, _right, _left, name, ctrl, gui) do
    IO.puts("#{name} is done")
    send(gui, :stop)
    send(ctrl, :done)
  end
  defp dreaming(hunger, right, left, name, ctrl, gui) do
    IO.puts("#{name} is dreaming their hunger is #{hunger}")

    send(gui, :leave)

    sleep(@dream)

    IO.puts("#{name} woke up")
    waitingChop(hunger, right, left, name, ctrl, gui)
  end

  defp waitingChop(hunger, right, left, name, ctrl, gui) do
    send(gui, :waiting)
    #IO.puts("#{name} is waiting for chopsticks")

    ref = make_ref()
    Chopstick.async(right, ref)
    Chopstick.async(left, ref)

    IO.inspect(ref)
    case Chopstick.synch(ref, @timeout) do
      :ok ->
        IO.puts("#{name} recieved the right chopstick")
        sleep(@timeout)
        case Chopstick.synch(ref, @timeout) do
          :ok ->
            sleep(100)
            IO.puts("#{name} has recieved both chopsticks")
            eating(hunger, right, left, name, ctrl, ref, gui)
          :no ->
            Chopstick.return(right, ref)
            #Chopstick.return(left, ref)
            dreaming(hunger, right, left, name, ctrl, gui)
        end
      :no ->
        #Chopstick.return(right, ref)
        #Chopstick.return(left, ref)
        dreaming(hunger, right, left, name, ctrl, gui)
    end
  end

  #####################################################################################

  # defp waitingChop(hunger, right, left, name, ctrl, gui) do
  #   send(gui, :waiting)
  #   IO.puts("#{name} is waiting for both chopsticks")
  #   x = Chopstick.request_both(right, left, 500)
  #   IO.inspect(x, label: "x")
  #   case x do
  #     :ok ->
  #       IO.puts("#{name} has recieved both chopsticks")
  #       eating(hunger, right, left, name, ctrl, gui)
  #     :no -> dreaming(hunger, right, left, name, ctrl, gui)
  #   end
  # end

  #####################################################################################

  defp eating(hunger, right, left, name, ctrl, ref, gui) do
    send(gui, :enter)
    IO.puts("#{name} is eating")
    sleep(@eat)
    IO.puts("#{name} has finished eating")

    Chopstick.return(right, ref)
    IO.puts("#{name} has left the right chopstick")

    Chopstick.return(left, ref)
    IO.puts("#{name} has left the left chopstick")

    dreaming(hunger - 1, right, left, name, ctrl, gui)
  end

  def sleep(0) do :ok end
  def sleep(t) do
    x = :rand.uniform(t)
    IO.inspect(x, label: "======================== x")
    :timer.sleep(x)
  end

end
