defmodule MyMacro do
  defmacro unless(clause, options) do
    quote do
      if !unquote(clause), unquote(options)
    end
  end
end
require MyMacro;
MyMacro.unless 2 + 2 == 5, do: IO.puts("unless")
m = Macro.expand_once(quote do
                    MyMacro.unless 2 + 2 == 5, do: IO.puts("unless")
                  end, __ENV__)
IO.puts Macro.to_string(m)
m = Macro.expand(quote do
                   MyMacro.unless 2 + 2 == 5, do: IO.puts("unless")
                 end, __ENV__)
IO.puts Macro.to_string(m)
