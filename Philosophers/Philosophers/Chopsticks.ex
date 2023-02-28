defmodule Chopstick do

  def start do
    spawn_link(fn -> init() end)
  end

  def init do
    available()
  end
#####################################
  # defp available() do
  #   receive do
  #     {:request, from} ->
  #       send(from, :granted)
  #       gone()
  #     :quit -> :ok
  #   end
  # end

  # defp gone() do
  #   receive do
  #     :return -> available()
  #     :quit -> :ok
  #   end
  # end
#######################################

defp available() do
  receive do
    {:request, ref, from} ->
      ## only used when we use refs
      send(from, {:granted, ref})
      gone(ref)

    :quit ->
      :ok
  end
end

defp gone(ref) do
  IO.inspect("---------------------------------------gone:")
  #IO.inspect(ref)
  receive do
    {:return, ^ref}->
      available()

    :quit ->
      :ok
  end
end
#
def return(stick) do send(stick, :return) end
def return(stick, ref) do
  send(stick, {:return, ref})
end

  # def request(stick, timeout) do
  #   send(stick, {:request, self()})

  #   receive do
  #     :granted -> :ok
  #   after timeout -> :no
  #   end
  # end

  # def request(stick, timeout) do
  #   case granted(right, left, timeout) do
  #     :ok -> :ok
  #     :no -> :no
  #   end
  #   #granted(right, left)
  #   send(stick, {:request, self()})
  #   receive do
  #     :granted -> :ok
  #   after timeout -> :no
  #   end
  # end

  # def granted(right, left, timeout) do
  #   x = 0;
  #   send(right, {:request, self()})
  #   send(left, {:request, self()})
  #   receive do
  #     :granted ->
  #       if(x == 1) do
  #         :ok
  #       else
  #         x = x + 1
  #       end
  #     after timeout -> :no
  #   end
  # end
#####################################################################################
  # def request_both(right, left, timeout) do
  #   right_granted = (request(right, timeout) == :granted)
  #   left_granted = (request(left, timeout) == :granted)

  #   IO.inspect(right_granted, label: "--------------------------------right_granted")
  #   IO.inspect(left_granted, label: "---------------------------------left_granted")

  #   if(right_granted && left_granted) do
  #     :ok
  #   else
  #     if(!right_granted && left_granted) do
  #       return(left)
  #       :no
  #     else
  #       if(right_granted && !left_granted) do
  #         return(right)
  #         :no
  #       else
  #         :no
  #       end
  #     end
  #   end
  # end

  # def request(stick, timeout) do
  #   send(stick, {:request, self()})

  #   receive do
  #     :granted -> :granted
  #   after timeout -> :false

  #   end
  # end
#####################################################################################

def async(stick, ref) do
  send(stick, {:request, ref, self()})
end

def synch(ref, timeout) do
  IO.inspect("----------------------------------------sync")
  receive do
    {:granted, ^ref} -> :ok
    {:granted, _} -> synch(ref, timeout)
  after timeout -> :no
  end
end

def request(stick, ref, timeout) do
  send(stick, {:request, self()})
  wait(ref, timeout)
end

defp wait(ref, timeout) do
  receive do
  {:granted, ^ref} -> :ok
    {:granted, _} -> wait(ref, timeout)
    after timeout -> :no
  end
end

  def quit(stick) do
    send(stick, :quit)
  end

end
