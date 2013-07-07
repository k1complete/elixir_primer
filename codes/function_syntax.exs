f = function do
  x, y when x > 0 -> x + y
  x, y -> x * y
end
f.(1, 3)
f.(-1, 3)
g = fn 
  x, y when x > 0 -> x + y
  x, y -> x * y
end
g.(1,3)
g.(-1,3)
