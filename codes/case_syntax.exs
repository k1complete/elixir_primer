x = 1
case [1,2,3] do
  [1,2,x] -> x
  x -> x
  _ -> 0
end
case [1,2,3] do
  x -> x
  [1,x,3] -> x
  _ -> 0
end
