defmodule MyMacro do
  defp makeargs(arity) do
    1..arity |> 
         Enum.map(fn(x) ->
                    arg = binary_to_atom("arg#{x}")
                    {arg, [], Elixir}
                  end)
  end
  defp delegate_1m([{fname, arity} | t], to: module) do
    args = makeargs(arity)
    e = quote do
      def unquote(fname).(unquote_splicing(args)) do
        apply unquote(module), unquote(fname), [unquote_splicing(args)]
      end
    end
    case t do
      [] -> [e]
      t -> [e | delegate_1m(t, to: module)]
    end
  end
  defmacro delegate_1(t, to: module) do
    delegate_1m(t, to: module)
  end
  defmacro delegate_2(tuplelist, to: module) when is_list(tuplelist) do
    tuplelist |> 
      Enum.map(fn({fname, arity}) ->
                   args = makeargs(arity)
                   quote do
                     def unquote(fname).(unquote_splicing(args)) do
                       apply unquote(module), unquote(fname), [unquote_splicing(args)]
                     end
                   end
               end)
  end
end
defmodule MyModule do
  require MyMacro
  MyMacro.delegate_1 [member?: 2, reverse: 1], to: Enum
end
MyModule.member?([1,2,3], 3)
MyModule.reverse([1,2,3])