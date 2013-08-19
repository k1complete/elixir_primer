defmodule MyMacro do
  defmacro plus(x) do
    {:"+", [], [x, x]}
  end
end
require MyMacro
MyMacro.plus(4)
IO.puts Macro.to_string(Macro.expand(quote do
                                       MyMacro.plus(4)
                                     end, __ENV__))
