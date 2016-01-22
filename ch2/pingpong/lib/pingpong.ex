defmodule PingPong do

   def ping do
    receive do
      {pong_pid, :pong} ->
        IO.puts "pong received"
        :timer.sleep(1000)
        send pong_pid, {self, :ping}
        ping
    end
  end


   def pong do
    receive do
      {ping_pid, :ping} ->
        IO.puts "ping received"
        :timer.sleep(1000)
        send ping_pid, {self, :pong}
        pong
    end
  end

  def start do
      ping_pid = spawn(__MODULE__, :ping, [])
      pong_pid = spawn(__MODULE__, :pong ,[])
      send pong_pid, {ping_pid, :ping}
  end

end
