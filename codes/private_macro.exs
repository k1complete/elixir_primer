defmodule MyMacro do
  defmacrop is_even(x) do
    quote do
      rem(unquote(x), 2) == 0
    end
  end
  def add_even(a, b) when is_even(a) and is_even(b) do
    a + b
  end
end

defmodule MyMacro2 do
  def add_even(a, b) when is_even(a) and is_even(b) do
    a + b
  end
  defmacrop is_even(x) do
    quote do
      rem(unquote(x), 2) == 0
    end
  end
end
