Enum.map([1,2,3,4,5], 
           fn(x) -> IO.puts("step1 #{x}+1"); x + 1 end) |>
Enum.take(3) |>
Enum.map fn(x) -> IO.puts("step3 #{x} + 1"); x + 1 end

