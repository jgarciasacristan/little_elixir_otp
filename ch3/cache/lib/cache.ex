defmodule Cache do

  use GenServer

   @name CacheExercise
  ## Client API
  
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def write(key, value) do
    GenServer.cast(@name, {:write, key, value})
  end

  def read(key) do
    GenServer.call(@name, {:read, key})
  end

  def delete(key) do
    GenServer.cast(@name, {:delete, key})
  end

  def exists?(key) do 
    GenServer.call(@name, {:exists, key})
  end 
  def clear do
    GenServer.cast(@name, :clear)
  end
  
  def stop do
    GenServer.cast(@name, :stop)
  end

  ## Server Callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:read, key}, _from, map) do
    {:reply, Map.get(map, key), map}    
  end

  def handle_call({:exists, key}, _from, map) do
    {:reply, Map.has_key?(map, key), map}
  end

  def handle_cast({:write, key, value}, map) do
    {:noreply, Map.put(map, key, value)}
  end

  def handle_cast({:delete, key}, map) do
    {:noreply, Map.delete(map,key)}
  end

  def handle_cast(:clear, _map) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, map) do
    {:stop, :normal, map}
  end

  def terminate(reason, map) do
    IO.puts "server termintated because of #{inspect reason}"
    IO.puts inspect map
    :ok
  end

  def handle_info(msg, map) do
    IO.puts "received #{inspect msg}"
    {:noreply, map}
  end

end
