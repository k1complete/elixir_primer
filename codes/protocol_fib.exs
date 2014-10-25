defmodule Fib do
  defstruct f0: 1, f1: 1, count: :infinity
  def new() do
    %Fib{}
  end
  def new(count) do
    %Fib{count: count}
  end
end
defimpl Enumerable, for: Fib do
  def count(%Fib{count: :infinity}) do
    {:error, __MODULE__}
  end
  def count(e) do
    {:ok, e.count}
  end
  def reduce(e, acc, fun) do
    reduce(e.f0, e.f1, e.count, acc, fun)
  end
  def reduce(_f0, _f1, 0, {:cont, acc}, _fun) do
    {:done, acc}
  end
  def reduce(f0, f1, :infinity, {:cont, acc}, fun) do
    reduce(f1, f0+f1, :infinity, fun.(f0, acc), fun)
  end
  def reduce(f0, f1, n, {:cont, acc}, fun) do
    reduce(f1, f0+f1, n-1, fun.(f0, acc), fun)
  end
  def reduce(_, _, _, {:halt, acc}, _fun) do
    {:halted, acc}
  end
  def reduce(f0, f1, n, {:suspend, acc}, fun) do
    {:suspended, acc, &reduce(f0, f1, n, &1, fun)}
  end
  def member?(_e, _i) do
    {:error, __MODULE__}
  end
end

