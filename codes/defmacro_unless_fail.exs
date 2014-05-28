defmodule MyMacro do
  defmacro unless(clause, options) do
    quote do
      if !clause, options
    end
  end
end
