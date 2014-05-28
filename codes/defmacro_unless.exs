defmodule MyMacro do
  defmacro unless(clause, options) do
    quote do
      if !unquote(clause), unquote(options)
    end
  end
end
