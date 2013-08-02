defmodule MyMacro do
  defmacro unless(clause, options) do
    quote do
      if !clause, options
    end
  end
end
require MyMacro;
Macro.expand_once(quote do
                    MyMacro.unless 2 + 2 == 5, do: IO.puts("unless")
                  end, __ENV__)
