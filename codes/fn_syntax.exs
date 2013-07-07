m = Macro.expand(quote do
  fn(x) -> x + 1 end
end, __ENV__)
