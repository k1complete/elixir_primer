defimpl Access, for: Fib do
  def get(a, :f0), do: a.f0
  def get(a, :f1), do: a.f1
  def get(a, :count), do: a.count
  def get_and_update(a, key, f) do
    {:ok, value} = :maps.find(key, a)
    {get, update} = f.(value)
    {get, :maps.put(key, update, a)}
  end
end


    