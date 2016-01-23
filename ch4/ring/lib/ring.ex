defmodule Ring do

  def create_processes(n) do
    1..n |> Enum.map(fn _ -> spawn(fn -> loop end) end)
  end

  def loop do 
    receive do
      {:link, link_to} when is_pid(link_to) ->
        Process.link(link_to)
        loop
      :trap_exit ->
        Process.flag(:trap_exit, true)
        loop
      :crash -> 1/0
      {:EXIT, pid, reason} ->
        IO.puts "#{inspect self} received {:EXIT, #{inspect pid}, #{reason}}"
        loop
    end
  end

  def link_processes(procs) do
    link_processes(procs, [])
  end

  def link_processes([p1, p2|rest], linked_processes) do
    send(p1, {:link, p2})
    link_processes([p2|rest], [p1|linked_processes])
  end

  def link_processes([proc|[]], linked_processes) do
    first_process = linked_processes |> List.last
    send(proc, {:link, first_process})
  end
end
