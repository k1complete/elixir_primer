defmodule Hygiene do
  defmacro testmacro do
    quote do: a = 1
  end
end
a = 10
require Hygiene; Hygiene.testmacro
a
defmodule Hygiene2 do
  defmacro testmacro do
    quote do: var!(a) = 1
  end
end
a = 10
require Hygiene2; Hygiene2.testmacro
a
Macro.expand_once(quote do
                    Hygiene.testmacro
                  end, __ENV__)
Macro.expand_once(quote do
                    Hygiene2.testmacro
                  end, __ENV__)
