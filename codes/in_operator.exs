y = 3
y in [1,2,3]

:lists.member(y, [1,2,3])
Enum.any?([1,2,3], fn(x) -> x == y end)
