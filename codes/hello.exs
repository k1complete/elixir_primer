defmodule ModuleName do
  def method_name(arg1) do
    {:body, arg1}
  end
  def short_method(arg1), do: {:body, arg1}
end
defmodule Hello do
  def world do
    IO.puts("Hello, world.")
  end
end
Hello.world
