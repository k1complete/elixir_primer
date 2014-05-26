# Get the current process id
current_pid = self
# Spawn another process that will send a message
spawn fn -> 
  self current_pid, { :hello, self }
end
# Collect the message
receive do
  { :hello, pid } ->
    IO.puts "Hello from #{inspect(pid)}"
end
